# Values schema documentation

This page lists all available configuration options, based on the [configuration values schema](values.schema.json).

Note that configuration options can change between releases. Use the GitHub function for selecting a branch/tag to view the documentation matching your cluster-aws version.

<!-- Update the content below by executing (from the repo root directory)

schemadocs generate helm/cluster-azure/values.schema.json -o helm/cluster-azure/README.md

-->

<!-- DOCS_START -->

### Cluster configuration
Properties within the `.Cluster configuration` top-level object
Configuration of an Azure cluster using Cluster API

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `Cluster configuration.baseDomain` | **Base DNS domain**|**Type:** `string`<br/>**Default:** `"azuretest.gigantic.io"`|
| `Cluster configuration.cluster-shared` | **Library chart**|**Type:** `object`<br/>|
| `Cluster configuration.connectivity` | **Connectivity**|**Type:** `object`<br/>|
| `Cluster configuration.connectivity.allowedCIDRs` | **List of CIDRs which have to been allowed to connect to the API Server endpoint**|**Type:** `array`<br/>**Default:** `[]`|
| `Cluster configuration.connectivity.allowedCIDRs[*]` |**None**|**Type:** `string`<br/>|
| `Cluster configuration.connectivity.bastion` | **Bastion host**|**Type:** `object`<br/>|
| `Cluster configuration.connectivity.bastion.enabled` | **Enable bastion host for this cluster**|**Type:** `boolean`<br/>**Default:** `true`|
| `Cluster configuration.connectivity.bastion.instanceType` | **VM size** - Type of virtual machine to use for the bastion host.|**Type:** `string`<br/>**Default:** `"Standard_D2s_v5"`|
| `Cluster configuration.connectivity.network` | **Network**|**Type:** `object`<br/>|
| `Cluster configuration.connectivity.network.controlPlane` | **Control plane**|**Type:** `object`<br/>|
| `Cluster configuration.connectivity.network.controlPlane.cidr` | **Subnet**|**Type:** `string`<br/>**Default:** `"10.0.0.0/20"`|
| `Cluster configuration.connectivity.network.hostCidr` | **Node subnet** - IPv4 address range for nodes, in CIDR notation.|**Type:** `string`<br/>**Default:** `"10.0.0.0/16"`|
| `Cluster configuration.connectivity.network.mode` | **Network mode** - Specifying if the cluster resources are publicly accessible or not.|**Type:** `string`<br/>**Default:** `"public"`|
| `Cluster configuration.connectivity.network.podCidr` | **Pod subnet** - IPv4 address range for pods, in CIDR notation.|**Type:** `string`<br/>**Default:** `"192.168.0.0/16"`|
| `Cluster configuration.connectivity.network.serviceCidr` | **Service subnet** - IPv4 address range for services, in CIDR notation.|**Type:** `string`<br/>**Default:** `"172.31.0.0/16"`|
| `Cluster configuration.connectivity.network.workers` | **Workers**|**Type:** `object`<br/>|
| `Cluster configuration.connectivity.network.workers.cidr` | **Subnet**|**Type:** `string`<br/>**Default:** `"10.0.16.0/20"`|
| `Cluster configuration.connectivity.sshSSOPublicKey` | **SSH Public key for single sign-on**|**Type:** `string`<br/>**Default:** `"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4cvZ01fLmO9cJbWUj7sfF+NhECgy+Cl0bazSrZX7sU vault-ca@vault.operations.giantswarm.io"`|
| `Cluster configuration.controlPlane` | **Control plane**|**Type:** `object`<br/>|
| `Cluster configuration.controlPlane.etcdVolumeSizeGB` | **Etcd volume size (GB)**|**Type:** `integer`<br/>**Default:** `10`|
| `Cluster configuration.controlPlane.instanceType` | **Node VM size**|**Type:** `string`<br/>**Default:** `"Standard_D4s_v3"`|
| `Cluster configuration.controlPlane.oidc` | **OIDC authentication**|**Type:** `object`<br/>|
| `Cluster configuration.controlPlane.oidc.caPem` | **Certificate authority** - Identity provider's CA certificate in PEM format.|**Type:** `string`<br/>**Default:** `""`|
| `Cluster configuration.controlPlane.oidc.clientId` | **Client ID**|**Type:** `string`<br/>**Default:** `""`|
| `Cluster configuration.controlPlane.oidc.groupsClaim` | **Groups claim**|**Type:** `string`<br/>**Default:** `""`|
| `Cluster configuration.controlPlane.oidc.issuerUrl` | **Issuer URL**|**Type:** `string`<br/>**Default:** `""`|
| `Cluster configuration.controlPlane.oidc.usernameClaim` | **Username claim**|**Type:** `string`<br/>**Default:** `""`|
| `Cluster configuration.controlPlane.replicas` | **Number of nodes**|**Type:** `integer`<br/>**Default:** `3`|
| `Cluster configuration.controlPlane.rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Default:** `50`|
| `Cluster configuration.internal` | **Internal settings**|**Type:** `object`<br/>|
| `Cluster configuration.internal.defaults` | **Default settings**|**Type:** `object`<br/>|
| `Cluster configuration.internal.defaults.evictionMinimumReclaim` | **Default settings for eviction minimum reclaim**|**Type:** `string`<br/>**Default:** `"imagefs.available=5%,memory.available=100Mi,nodefs.available=5%"`|
| `Cluster configuration.internal.defaults.hardEvictionThresholds` | **Default settings for hard eviction thresholds**|**Type:** `string`<br/>**Default:** `"memory.available\u003c200Mi,nodefs.available\u003c10%,nodefs.inodesFree\u003c3%,imagefs.available\u003c10%,pid.available\u003c20%"`|
| `Cluster configuration.internal.defaults.softEvictionGracePeriod` | **Default settings for soft eviction grace period**|**Type:** `string`<br/>**Default:** `"memory.available=30s,nodefs.available=2m,nodefs.inodesFree=1m,imagefs.available=2m,pid.available=1m"`|
| `Cluster configuration.internal.defaults.softEvictionThresholds` | **Default settings for soft eviction thresholds**|**Type:** `string`<br/>**Default:** `"memory.available\u003c500Mi,nodefs.available\u003c15%,nodefs.inodesFree\u003c5%,imagefs.available\u003c15%,pid.available\u003c30%"`|
| `Cluster configuration.internal.identity` | **Identity**|**Type:** `object`<br/>|
| `Cluster configuration.internal.identity.attachCapzControllerUserAssignedIdentity` | **Attach CAPZ controller UserAssigned identity**|**Type:** `boolean`<br/>**Default:** `false`|
| `Cluster configuration.internal.identity.systemAssignedScope` | **Scope of SystemAssignedIdentity**|**Type:** `string`<br/>**Default:** `"ResourceGroup"`|
| `Cluster configuration.internal.identity.type` | **Type of Identity**|**Type:** `string`<br/>**Default:** `"SystemAssigned"`|
| `Cluster configuration.internal.identity.userAssignedCustomIdentities` | **List of custom UserAssigned Identities to attach to all nodes**|**Type:** `array`<br/>**Default:** `[]`|
| `Cluster configuration.internal.image` | **Node Image**|**Type:** `object`<br/>|
| `Cluster configuration.internal.image.gallery` | **Gallery** - Name of the community gallery hosting the image|**Type:** `string`<br/>**Default:** `"gsCapzFlatcar-41c2d140-ac44-4d8b-b7e1-7b2f1ddbe4d0"`|
| `Cluster configuration.internal.image.name` | **Image Definition** - Name of the image definition in the Gallery|**Type:** `string`<br/>**Default:** `""`|
| `Cluster configuration.internal.image.version` | **Image version**|**Type:** `string`<br/>**Default:** `"3374.2.4"`|
| `Cluster configuration.internal.kubernetesVersion` | **Kubernetes version**|**Type:** `string`<br/>**Default:** `"1.24.11"`|
| `Cluster configuration.internal.network` | **Network configuration** - Internal network configuration that is susceptible to more frequent change|**Type:** `object`<br/>|
| `Cluster configuration.internal.network.subnets` | **VNet spec** - Customize subnets configuration|**Type:** `object`<br/>**Default:** `{}`|
| `Cluster configuration.internal.network.subnets.controlPlaneSubnetName` | **ControlPlane subnet name** - Name of the control plane subnet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `Cluster configuration.internal.network.subnets.nodeSubnetNatGatewayName` | **Nodes subnet nat-gateway name** - Name of the nat gateway on the nodes subnet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `Cluster configuration.internal.network.subnets.nodesSubnetName` | **Nodes subnet name** - Name of the nodes subnet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `Cluster configuration.internal.network.vnet` | **VNet spec** - Existing VNet configuration. This is susceptible to more frequent change or removal.|**Type:** `object`<br/>**Default:** `{}`|
| `Cluster configuration.internal.network.vnet.name` | **VNet name** - Name of the existing VNet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `Cluster configuration.internal.network.vnet.resourceGroup` | **Resource group name** - Resource group where the existing VNet is deployed.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._\(\)]+$`<br/>|
| `Cluster configuration.internal.network.vpn` | **VPN configuration** - Internal VPN configuration that is susceptible to more frequent change|**Type:** `object`<br/>|
| `Cluster configuration.internal.network.vpn.gatewayMode` | **VPN gateway mode**|**Type:** `string`<br/>**Default:** `"none"`|
| `Cluster configuration.managementCluster` | **The capi MC managing this cluster**|**Type:** `string`<br/>|
| `Cluster configuration.metadata` | **Metadata**|**Type:** `object`<br/>|
| `Cluster configuration.metadata.description` | **Cluster description** - User-friendly description of the cluster's purpose.|**Type:** `string`<br/>|
| `Cluster configuration.metadata.name` | **Cluster name** - Unique identifier, cannot be changed after creation.|**Type:** `string`<br/>|
| `Cluster configuration.metadata.organization` | **Organization**|**Type:** `string`<br/>|
| `Cluster configuration.metadata.servicePriority` | **Service priority** - The relative importance of this cluster.|**Type:** `string`<br/>**Default:** `"highest"`|
| `Cluster configuration.nodePools` | **Node pools**|**Type:** `array`<br/>**Default:** `[{"customNodeLabels":[],"customNodeTaints":[],"disableHealthCheck":false,"instanceType":"Standard_D2s_v3","name":"md00","replicas":3,"rootVolumeSizeGB":50}]`|
| `Cluster configuration.nodePools[*]` | **Node pool**|**Type:** `object`<br/>|
| `Cluster configuration.nodePools[*].customNodeLabels` | **Custom node labels**|**Type:** `array`<br/>|
| `Cluster configuration.nodePools[*].customNodeLabels[*]` | **Label**|**Type:** `string`<br/>|
| `Cluster configuration.nodePools[*].customNodeTaints` | **Custom node taints**|**Type:** `array`<br/>|
| `Cluster configuration.nodePools[*].customNodeTaints[*]` | **Node taint**|**Type:** `object`<br/>|
| `Cluster configuration.nodePools[*].customNodeTaints[*].effect` | **Effect**|**Type:** `string`<br/>|
| `Cluster configuration.nodePools[*].customNodeTaints[*].key` | **Key**|**Type:** `string`<br/>|
| `Cluster configuration.nodePools[*].customNodeTaints[*].value` | **Value**|**Type:** `string`<br/>|
| `Cluster configuration.nodePools[*].disableHealthCheck` | **Disable HealthChecks for the MachineDeployment**|**Type:** `boolean`<br/>|
| `Cluster configuration.nodePools[*].failureDomain` | **Select zone where to deploy the nodePool**|**Type:** `string`<br/>|
| `Cluster configuration.nodePools[*].instanceType` | **VM size**|**Type:** `string`<br/>|
| `Cluster configuration.nodePools[*].name` | **Name** - Unique identifier, cannot be changed after creation.|**Type:** `string`<br/>|
| `Cluster configuration.nodePools[*].replicas` | **Number of nodes**|**Type:** `integer`<br/>|
| `Cluster configuration.nodePools[*].rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>|
| `Cluster configuration.provider` | **Cluster API provider name**|**Type:** `string`<br/>|
| `Cluster configuration.providerSpecific` | **Azure settings**|**Type:** `object`<br/>|
| `Cluster configuration.providerSpecific.azureClusterIdentity` | **Identity** - AzureClusterIdentity resource to use for this cluster.|**Type:** `object`<br/>|
| `Cluster configuration.providerSpecific.azureClusterIdentity.name` | **Name**|**Type:** `string`<br/>**Default:** `"cluster-identity"`|
| `Cluster configuration.providerSpecific.azureClusterIdentity.namespace` | **Namespace**|**Type:** `string`<br/>**Default:** `"org-giantswarm"`|
| `Cluster configuration.providerSpecific.location` | **Location**|**Type:** `string`<br/>**Default:** `"westeurope"`|
| `Cluster configuration.providerSpecific.network` | **Azure network settings** - Azure VNet peering and other Azure-specific network settings.|**Type:** `object`<br/>|
| `Cluster configuration.providerSpecific.network.peerings` | **VNet peerings** - Specifying VNets (their resource groups and names) to which the peering is established.|**Type:** `array`<br/>**Default:** `[]`|
| `Cluster configuration.providerSpecific.network.peerings[*]` | **VNet peering**|**Type:** `object`<br/>|
| `Cluster configuration.providerSpecific.network.peerings[*].remoteVnetName` | **VNet name** - Name of the remote VNet to which the peering is established.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `Cluster configuration.providerSpecific.network.peerings[*].resourceGroup` | **Resource group name** - Resource group for the remote VNet to which the peering is established.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._\(\)]+$`<br/>|
| `Cluster configuration.providerSpecific.subscriptionId` | **Subscription ID**|**Type:** `string`<br/>|



<!-- DOCS_END -->
