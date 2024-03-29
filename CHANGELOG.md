# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2024-03-26

### Added

- Add default tag `giantswarm-cluster` to all resources.

## [0.4.0] - 2024-03-26

### Added

- Allow adding custom tags to resources using `providerSpecific.additionalResourceTags` value.

## [0.3.0] - 2024-03-07

### Changed

- Allow additional fields for `privateEndpoints`.

## [0.2.0] - 2024-02-21

### Changed

- Allow adding `privateEndpoints` to subnets.

## [0.1.1] - 2024-02-16

## [0.1.0] - 2024-02-14

### Changed

- Use `Standard_D4s_v5` for control plane and worker nodes.
- Use 2 replicas for workers by default.
- Upgrade K8S version to `1.25.16`.
- Upgrade kubectl version to `1.25.15`.
- Disable PSPs by default.

## [0.0.35] - 2024-02-07

### Removed

- SSH inbound SG rule from VPN

## [0.0.34] - 2024-02-05

### Removed

- Bastion and ssh configuration on nodes.

## [0.0.33] - 2024-01-23

### Changed

- Enable Host Encryption for workers and control plane virtual machines.
- Use `gsoci.azurecr.io` for `kubeadm` container images.
- Use `gsoci.azurecr.io` for sandbox container image (pause container).
- Update `coredns` to `1.21.0` to use `gsoci.azurecr.io`.
- Update `cillium` to `0.19.2` to use `gsoci.azurecr.io`.
- Update `azure-cloud-controller-manager-app` to `1.24.18-gs6` to use `gsoci.azurecr.io`.
- Update `azure-cloud-node-manager-app` to `1.24.18-gs6` to use `gsoci.azurecr.io`.
- Update `azuredisk-csi-driver-app` to `1.26.2-gs6` to use `gsoci.azurecr.io`.
- Update `azurefile-csi-driver-app` to `1.26.0-gs4` to use `gsoci.azurecr.io`.

## [0.0.32] - 2023-12-20

### Changed

- Enable teleport by default.
- Upgrade Flatcar image to [3510.2.5](https://www.flatcar.org/releases#release-3510.2.5)
- Upgrade K8S version to `1.24.17`
- Fix left-over azurefile-csi-driver helmreleases during cleanup.
- Adapt cleanup hook for cluster policies.

## [0.0.31] - 2023-12-14

### Added

- Add `azurefile-csi-driver` app as helmrelease.

## [0.0.30] - 2023-12-13

### Added

- Add validation of machineDeployment name using Schema Regex
- Add flags to disable PSPs.

### Fixed

- Fix containerd config that was breaking in newer flatcar versions.

## [0.0.29] - 2023-08-03

### Changed

- :boom: Migrate CNI / CPI / CSI and VPA CRD apps to helmreleases in cluster-azure - requires `default-apps-azure` 0.0.24

## [0.0.28] - 2023-07-31

### Changed

- Use multiple volumes for `containerd`,`kubelet`,`root` and `etcd` mounts for **control plane** nodes

## [0.0.27] - 2023-07-13

### Added

- Render `containerd` configuration at cluster creation time
  - add support for containerd registry mirrors
  - add support for containerd registry credentials


### Added

- Set value for `controller-manager` `terminated-pod-gc-threshold` to `125` ( consistent with vintage )

## [0.0.26] - 2023-06-28

### Changed

- Restricted `.providerSpecific.location` value to a set of defined region names.
- Disallow additional properties on the `.metadata.labels` object.

### Added

- Deploy private links for private clusters.

## [0.0.25] - 2023-06-14

### Changed

- Value `.providerSpecific.subscriptionId` marked as required, constrained to UUID format.
- `Enabled Admission Plugins` is now handled dynamically based on the kubernetes version of the cluster that is being installed
- `Feature Gates` is now handled dynamically based on the kubernetes version of the cluster that is being installed

### Removed

- Remove CSIMigration feature flag (enabled by default with k8s 1.23).

## [0.0.24] - 2023-06-07

### Changed

- Add support for configurable labels to Cluster CR

## [0.0.23] - 2023-06-01

### Changed

- Upgrade `cluster-shared` dependency to `0.6.5`
- Add value schema constraints to all numeric types, using `exclusiveMinimum` or `minimum` of zero.

## [0.0.22] - 2023-05-17

### Changed

- Upgrade Flatcar image to [3510.2.1](https://www.flatcar.org/releases#release-3510.2.1)
- Upgrade K8S version to `1.24.13`

### Added

- Add full configuration values documentation.

## [0.0.21] - 2023-05-15

### Changed
- :boom: Breaking - Skip `kube-proxy` during kubeadm init/join to replace with cilium-proxy
  - This change requies default-apps >= 0.0.17

## [0.0.20] - 2023-04-26

### Changed

- Add `identity spec` to hash calculation for bastion node

## [0.0.19] - 2023-04-18

### Changed
- Add `connectivity.allowedCIDRs` to define a list of network addresses to connect to the API server.
- Support defining custom vnet settings ( in the /internal section  of the schema )
  - VNET name and ResourceGroup
  - precreated subnet names
- Allow defining the scope of the SystemAssigned Identity on WC nodes

## [0.0.18] - 2023-04-05

### Changed

- Rename JSON schema makefile commands to `normalize-schema`, `validate-schema`, `generate-values`.
- Add replacement of pause image for kubelet and containerd to use `quay.io/giantswarm/pause`
- Revert `cilium kube-proxy` replacement - do not skip kube-proxy
  - Requires default-apps => 0.0.15

## [0.0.17] - 2023-04-04

### Added

- Add support for private clusters.

### Changed

- :boom: Breaking - Skip `kube-proxy` during kubeadm init/join to replace with cilium-proxy
  - This change requies default-apps >= 0.0.14

## [0.0.16] - 2023-03-27

### Added

- Add support for failuredomains field to MachineDeployments

### Changed

- Remove machinepool code , this code is currently not used and it will confused the team that picks up this APP

## [0.0.15] - 2023-03-13

### Changed

- Add support for creating WC with SystemAssigned Identities and make it the default - `Contributor` Role in the `resourceGroup` where the cluster Lives

## [0.0.14] - 2023-03-08

### Changed

- Switch Cluster Images from Ubuntu to Flatcar
- Port hardening and tuning settings from Vintage to CAPZ Flatcar
- Fix `schema-normalize` Make target to actually do the normalize

## [0.0.13] - 2023-02-28

### Added

- Generate SAN entries for `api.<clusterName>.<baseDomain>` (e.g. `api.glippy.azuretest.gigantic.io`)

## [0.0.12] - 2023-02-27

### Changed

- **Breaking change** to values schema - make sure to update your values before updating to this releaseValues schema:
  - Rename /machineDeployments to /nodePools
  - Remove /machinePools from schema
- Values schema: Use draft 2020-12 and update default value encoding based on latest `schemalint normalize` output.
- Cluster Example: Update to match release 0.0.12 changes

## [0.0.11] - 2023-02-15

### Changed

- Add `managementCluster`, `baseDomain` and `provider` properties to the schema because they are added by the AppOperator and the schema has `additionalProperties: false`

## [0.0.10] - 2023-02-15

### Changed

- Re-Add selector to Bastion machineDeployment , this is a required field and the webhook validation fail without it ( only in our kind mc-bootstrap)

## [0.0.9] - 2023-02-15

### Changed

- Update example manifests to create cluster
- Re-Add selector to machineDeployment , this is a required field and the webhook validation fail without it ( only in our kind mc-bootstrap)

## [0.0.8] - 2023-02-15

### Changed

- Disallow additional properties on the values scherma root level.
- Reduce default network range from 10.0.0.0/8 (default CAPZ) to 10.0.0.0/16.

### Removed

- Removed `baseDomain` from CI values.

## [0.0.7] - 2023-02-14

### Added

- Add option to specify the `giantswarm.io/service-priority` cluster label.
- Add icon property to Chart metadata.
- Pre-Create /var/lib/kubelet with `0750` if it does not exist already to address issue with node-exporter
- Add example manifests to create cluster

### Changed

- **Breaking change** to values schema - make sure to update your values before updating to this releaseValues schema:
  - Renamed /azure to /providerSpecific
  - Moved /bastion to /connectivity/bastion
  - Moved /oidc to /controlPlane/oidc
  - Moved /defaults to /internal/defaults
  - Moved /attachCapzControllerIdentity into /internal/identy
  - Moved /enablePerClusterIdentity into /internal/identy
  - Moved /sshSSOPublicKey to /connectivity/sshSSOPublicKey
  - Moved /kubernetesVersion to /internal/kubernetesVersion

### Removed

- Values schema
  - Removed redundant and unused /clusterName and /clusterDescription properties.
  - Removed unused /includeClusterResourceSet

## [0.0.6] - 2023-02-08

### Added

- Add support for Bastion host as a MachineDeployment

## [0.0.5] - 2023-02-08

**Breaking Change** - make sure to update your values before updating to this release

- Values schema:
  - Moved /clusterName to /metadata/name
  - Moved /clusterDescription to /metadata/description
  - Moved /organization to /metadata/organization

## [0.0.4] - 2023-02-01

### Added

- Add support for MachineDeployments
- Add MachineDeployments to Values.yaml
- Add MachineHealthChecks for Worker Nodes in MachineDeployments. Enabled by default

### Changed

- Move common templates between MachineDeployments and MachinePools into an helper file ( \_machine_helpers.tpl )

## [0.0.3] - 2023-01-19

### Added

- Enable PodSecurityPolicy admission plugin when version is `lt` 1.25.0
- Add helm chart dependency for `cluster-shared` , required by the PSP admission controller
- Default to 3 replicas for control plane
- add giantswam user to the KCP and Machinepool configuration
- Add support for custom taints and labels on machinepools
  - also add hardcoded `role=worker` and `giantswarm.io/machine-pool` labels
- Add support for custom taints on control plane nodes
- Set EvictionThresholds soft and hard on all nodes
- Add a script to calculate the `kube-reserved` settings for nodes based on the available CPU and Memory using the formulas defined by [GKE](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture#memory_cpu)
  - The memory reservation is slighly less aggressive than what GKE suggests

## [0.0.2] - 2023-01-03

### Added

- Initial support to create a workload cluster via CAPI/CAPZ.
- Add support for creating cluster with `UserAssigned Identity` for `VM Identity`
- Add `cluster.x-k8s.io/watch-filter: capi` to common labels.


### Changed

- replace version with `0.0.0-dev` in Chart.yaml since we use App Build Suite
- Allow customizing the `identityRef` in the `AzureCluster`
- Fix MachinePool naming by removing the hashed name from all resources. This is not needed for MachinePools , like it is for MachineDeployments
- Skip `coredns` installation phase in `kubeadmbootstrapconfiguration` , we install it as an App
- Do not consider the `labels` in the ControlPlane AzureMachineTemplate when calculating name hash to avoid rolling control plane nodes unecessarily
- Change default values ssh key to RSA one ( since azure does not support ed25519 )
- Update schema json

## [0.0.1] - 2022-11-22

### Added

- Added github automation

## [0.0.1] - 2022-11-22

[Unreleased]: https://github.com/giantswarm/cluster-azure/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/giantswarm/cluster-azure/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/giantswarm/cluster-azure/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/giantswarm/cluster-azure/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/giantswarm/cluster-azure/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/giantswarm/cluster-azure/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/giantswarm/cluster-azure/compare/v0.0.35...v0.1.0
[0.0.35]: https://github.com/giantswarm/cluster-azure/compare/v0.0.34...v0.0.35
[0.0.34]: https://github.com/giantswarm/cluster-azure/compare/v0.0.33...v0.0.34
[0.0.33]: https://github.com/giantswarm/cluster-azure/compare/v0.0.32...v0.0.33
[0.0.32]: https://github.com/giantswarm/cluster-azure/compare/v0.0.31...v0.0.32
[0.0.31]: https://github.com/giantswarm/cluster-azure/compare/v0.0.30...v0.0.31
[0.0.30]: https://github.com/giantswarm/cluster-azure/compare/v0.0.29...v0.0.30
[0.0.29]: https://github.com/giantswarm/cluster-azure/compare/v0.0.28...v0.0.29
[0.0.28]: https://github.com/giantswarm/cluster-azure/compare/v0.0.27...v0.0.28
[0.0.27]: https://github.com/giantswarm/cluster-azure/compare/v0.0.26...v0.0.27
[0.0.26]: https://github.com/giantswarm/cluster-azure/compare/v0.0.25...v0.0.26
[0.0.25]: https://github.com/giantswarm/cluster-azure/compare/v0.0.24...v0.0.25
[0.0.24]: https://github.com/giantswarm/cluster-azure/compare/v0.0.23...v0.0.24
[0.0.23]: https://github.com/giantswarm/cluster-azure/compare/v0.0.22...v0.0.23
[0.0.22]: https://github.com/giantswarm/cluster-azure/compare/v0.0.21...v0.0.22
[0.0.21]: https://github.com/giantswarm/cluster-azure/compare/v0.0.20...v0.0.21
[0.0.20]: https://github.com/giantswarm/cluster-azure/compare/v0.0.19...v0.0.20
[0.0.19]: https://github.com/giantswarm/cluster-azure/compare/v0.0.18...v0.0.19
[0.0.18]: https://github.com/giantswarm/cluster-azure/compare/v0.0.17...v0.0.18
[0.0.17]: https://github.com/giantswarm/cluster-azure/compare/v0.0.17...v0.0.17
[0.0.17]: https://github.com/giantswarm/cluster-azure/compare/v0.0.16...v0.0.17
[0.0.16]: https://github.com/giantswarm/cluster-azure/compare/v0.0.15...v0.0.16
[0.0.15]: https://github.com/giantswarm/cluster-azure/compare/v0.0.14...v0.0.15
[0.0.14]: https://github.com/giantswarm/cluster-azure/compare/v0.0.13...v0.0.14
[0.0.13]: https://github.com/giantswarm/cluster-azure/compare/v0.0.12...v0.0.13
[0.0.12]: https://github.com/giantswarm/cluster-azure/compare/v0.0.11...v0.0.12
[0.0.11]: https://github.com/giantswarm/cluster-azure/compare/v0.0.10...v0.0.11
[0.0.10]: https://github.com/giantswarm/cluster-azure/compare/v0.0.9...v0.0.10
[0.0.9]: https://github.com/giantswarm/cluster-azure/compare/v0.0.8...v0.0.9
[0.0.8]: https://github.com/giantswarm/cluster-azure/compare/v0.0.7...v0.0.8
[0.0.7]: https://github.com/giantswarm/cluster-azure/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/giantswarm/cluster-azure/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/giantswarm/cluster-azure/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/giantswarm/cluster-azure/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/giantswarm/cluster-azure/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/giantswarm/cluster-azure/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/giantswarm/cluster-azure/compare/v0.0.1...v0.0.1
[0.0.1]: https://github.com/giantswarm/cluster-azure/releases/tag/v0.0.1
