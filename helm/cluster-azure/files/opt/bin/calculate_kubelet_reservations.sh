#!/bin/bash
# shellcheck disable=SC2004,SC2206,SC2155
set -e

# Values for reservation copied from https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture#memory_cpu
# Code copied mostly from https://github.com/awslabs/amazon-eks-ami/blob/master/files/bootstrap.sh#L446

# Helper function which calculates the amount of the given resource (either CPU or memory)
# to reserve in a given resource range, specified by a start and end of the range and a percentage
# of the resource to reserve. Note that we return zero if the start of the resource range is
# greater than the total resource capacity on the node. Additionally, if the end range exceeds the total
# resource capacity of the node, we use the total resource capacity as the end of the range.
# Args:
#   $1 total available resource on the worker node in input unit (either millicores for CPU or Mi for memory)
#   $2 start of the resource range in input unit
#   $3 end of the resource range in input unit
#   $4 percentage of range to reserve in percent*100 (to allow for two decimal digits)
# Return:
#   amount of resource to reserve in input unit
get_resource_to_reserve_in_range() {
  local total_resource_on_instance=$1
  local start_range=$2
  local end_range=$3
  local percentage=$4
  resources_to_reserve="0"
  if (($total_resource_on_instance > $start_range)); then
    resources_to_reserve=$(((($total_resource_on_instance < $end_range ? $total_resource_on_instance : $end_range) - $start_range) * $percentage / 100 / 100))
  fi
  echo $resources_to_reserve
}

# Calculates the amount of CPU to reserve for kubeReserved in millicores from the total number of vCPUs available on the instance.
# From the total core capacity of this worker node, we calculate the CPU resources to reserve by reserving a percentage
# of the available cores in each range up to the total number of cores available on the instance.
# We are using these CPU ranges from GKE (https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture#node_allocatable):
# 6% of the first core
# 1% of the next core (up to 2 cores)
# 0.5% of the next 2 cores (up to 4 cores)
# 0.25% of any cores above 4 cores
# Return:
#   CPU resources to reserve in millicores (m)
get_cpu_millicores_to_reserve() {
  local total_cpu_on_instance=$(($(nproc) * 1000))
  local cpu_ranges=(0 1000 2000 4000 "$total_cpu_on_instance")
  local cpu_percentage_reserved_for_ranges=(600 100 50 25)
  cpu_to_reserve="0"
  for i in "${!cpu_percentage_reserved_for_ranges[@]}"; do
    local start_range=${cpu_ranges[$i]}
    local end_range=${cpu_ranges[(($i + 1))]}
    local percentage_to_reserve_for_range=${cpu_percentage_reserved_for_ranges[$i]}
    cpu_to_reserve=$(($cpu_to_reserve + $(get_resource_to_reserve_in_range "$total_cpu_on_instance" "$start_range" "$end_range" "$percentage_to_reserve_for_range")))
  done
  echo $cpu_to_reserve
}

# NOTE I reduced the percentage of the first 3 ranges
#25% of the first 4 GiB of memory
#20% of the next 4 GiB of memory (up to 8 GiB)
#10% of the next 8 GiB of memory (up to 16 GiB)
#6% of the next 112 GiB of memory (up to 128 GiB)
#2% of any memory above 128 GiB

get_memory_to_reserve() {
  local total_memory_on_instance_in_bytes=$( awk '/MemTotal/ {print $2}' /proc/meminfo )
  local memory_ranges=(0 4000000 8000000 16000000 128000000 $total_memory_on_instance_in_bytes)
  #local memory_percentage_reserved_for_ranges=(2500 2000 1000 600 200)
  local memory_percentage_reserved_for_ranges=(2000 1500 800 600 200)
  memory_to_reserve_in_kbytes="0"
  for i in "${!memory_percentage_reserved_for_ranges[@]}"; do
    local start_range=${memory_ranges[$i]}
    local end_range=${memory_ranges[(($i + 1))]}
    local percentage_to_reserve_for_range=${memory_percentage_reserved_for_ranges[$i]}
    memory_to_reserve_in_kbytes=$(($memory_to_reserve_in_kbytes + $(get_resource_to_reserve_in_range "$total_memory_on_instance_in_bytes" "$start_range" "$end_range" "$percentage_to_reserve_for_range")))
  done
  # Output in Mi
  echo $memory_to_reserve_in_kbytes/1024 | bc
}

# add Settings to KUBELET_EXTRA_ARGS in /etc/default/kubelet
sed -i -e "/^KUBELET_EXTRA_ARGS/ s/$/ --kube-reserved=cpu=$(get_cpu_millicores_to_reserve)m,memory=$(get_memory_to_reserve)Mi/" /etc/default/kubelet
