# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/giantswarm/cluster-azure/compare/v0.0.2...HEAD
[0.0.2]: https://github.com/giantswarm/cluster-azure/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/giantswarm/cluster-azure/compare/v0.0.1...v0.0.1
[0.0.1]: https://github.com/giantswarm/cluster-azure/releases/tag/v0.0.1

