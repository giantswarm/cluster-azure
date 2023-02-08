# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.5] - 2023-02-08

### Changed

**Breaking Change** - make sure to update your values before updating to this release
- Values schema:
  - Moved /clusterName to /metadata/name
  - Moved /clusterDescription to /metadata/description
  - Moved /organization to /metadata/organization
  - Renamed /azure to /provider

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

[Unreleased]: https://github.com/giantswarm/cluster-azure/compare/v0.0.5...HEAD
[0.0.5]: https://github.com/giantswarm/cluster-azure/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/giantswarm/cluster-azure/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/giantswarm/cluster-azure/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/giantswarm/cluster-azure/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/giantswarm/cluster-azure/compare/v0.0.1...v0.0.1
[0.0.1]: https://github.com/giantswarm/cluster-azure/releases/tag/v0.0.1

