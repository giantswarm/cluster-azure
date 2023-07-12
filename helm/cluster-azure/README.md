# Values schema documentation

This page lists all available configuration options, based on the [configuration values schema](values.schema.json).

Note that configuration options can change between releases. Use the GitHub function for selecting a branch/tag to view the documentation matching your cluster-aws version.

<!-- Update the content below by executing (from the repo root directory)

schemadocs generate helm/cluster-azure/values.schema.json -o helm/cluster-azure/README.md

-->

<!-- DOCS_START -->

### Azure settings
Properties within the `.providerSpecific` top-level object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `providerSpecific.azureClusterIdentity` | **Identity** - AzureClusterIdentity resource to use for this cluster.|**Type:** `object`<br/>|
| `providerSpecific.azureClusterIdentity.name` | **Name**|**Type:** `string`<br/>**Default:** `"cluster-identity"`|
| `providerSpecific.azureClusterIdentity.namespace` | **Namespace**|**Type:** `string`<br/>**Default:** `"org-giantswarm"`|
| `providerSpecific.location` | **Location**|**Type:** `string`<br/>**Default:** `"westeurope"`|
| `providerSpecific.network` | **Azure network settings** - Azure VNet peering and other Azure-specific network settings.|**Type:** `object`<br/>|
| `providerSpecific.network.peerings` | **VNet peerings** - Specifying VNets (their resource groups and names) to which the peering is established.|**Type:** `array`<br/>**Default:** `[]`|
| `providerSpecific.network.peerings[*]` | **VNet peering**|**Type:** `object`<br/>|
| `providerSpecific.network.peerings[*].remoteVnetName` | **VNet name** - Name of the remote VNet to which the peering is established.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `providerSpecific.network.peerings[*].resourceGroup` | **Resource group name** - Resource group for the remote VNet to which the peering is established.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._\(\)]+$`<br/>|
| `providerSpecific.subscriptionId` | **Subscription ID** - ID of the Azure subscription this cluster will run in.|**Type:** `string`<br/>**Example:** `"291bba3f-e0a5-47bc-a099-3bdcb2a50a05"`<br/>**Value pattern:** `^[a-fA-F0-9][-a-fA-F0-9]+[a-fA-F0-9]$`<br/>|

### Connectivity
Properties within the `.connectivity` top-level object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `connectivity.allowedCIDRs` | **List of CIDRs which have to been allowed to connect to the API Server endpoint**|**Type:** `array`<br/>**Default:** `[]`|
| `connectivity.allowedCIDRs[*]` |**None**|**Type:** `string`<br/>|
| `connectivity.bastion` | **Bastion host**|**Type:** `object`<br/>|
| `connectivity.bastion.enabled` | **Enable bastion host for this cluster**|**Type:** `boolean`<br/>**Default:** `true`|
| `connectivity.bastion.instanceType` | **VM size** - Type of virtual machine to use for the bastion host.|**Type:** `string`<br/>**Default:** `"Standard_D2s_v5"`|
| `connectivity.containerRegistries` | **Container registries** - Endpoints and credentials configuration for container registries.|**Type:** `object`<br/>**Default:** `{"docker.io":[{"endpoint":"registry-1.docker.io"},{"endpoint":"giantswarm.azurecr.io"}]}`|
| `connectivity.containerRegistries.*` | **Registries** - Container registries and mirrors|**Type:** `array`<br/>|
| `connectivity.containerRegistries.*[*]` | **Registry**|**Type:** `object`<br/>|
| `connectivity.containerRegistries.*[*].credentials` | **Credentials**|**Type:** `object`<br/>|
| `connectivity.containerRegistries.*[*].credentials.auth` | **Auth** - Base64-encoded string from the concatenation of the username, a colon, and the password.|**Type:** `string`<br/>|
| `connectivity.containerRegistries.*[*].credentials.identitytoken` | **Identity token** - Used to authenticate the user and obtain an access token for the registry.|**Type:** `string`<br/>|
| `connectivity.containerRegistries.*[*].credentials.password` | **Password** - Used to authenticate for the registry with username/password.|**Type:** `string`<br/>|
| `connectivity.containerRegistries.*[*].credentials.username` | **Username** - Used to authenticate for the registry with username/password.|**Type:** `string`<br/>|
| `connectivity.containerRegistries.*[*].endpoint` | **Endpoint** - Endpoint for the container registry.|**Type:** `string`<br/>|
| `connectivity.network` | **Network**|**Type:** `object`<br/>|
| `connectivity.network.controlPlane` | **Control plane**|**Type:** `object`<br/>|
| `connectivity.network.controlPlane.cidr` | **Subnet**|**Type:** `string`<br/>**Default:** `"10.0.0.0/20"`|
| `connectivity.network.hostCidr` | **Node subnet** - IPv4 address range for nodes, in CIDR notation.|**Type:** `string`<br/>**Default:** `"10.0.0.0/16"`|
| `connectivity.network.mode` | **Network mode** - Specifying if the cluster resources are publicly accessible or not.|**Type:** `string`<br/>**Default:** `"public"`|
| `connectivity.network.podCidr` | **Pod subnet** - IPv4 address range for pods, in CIDR notation.|**Type:** `string`<br/>**Default:** `"192.168.0.0/16"`|
| `connectivity.network.serviceCidr` | **Service subnet** - IPv4 address range for services, in CIDR notation.|**Type:** `string`<br/>**Default:** `"172.31.0.0/16"`|
| `connectivity.network.workers` | **Workers**|**Type:** `object`<br/>|
| `connectivity.network.workers.cidr` | **Subnet**|**Type:** `string`<br/>**Default:** `"10.0.16.0/20"`|
| `connectivity.sshSSOPublicKey` | **SSH Public key for single sign-on**|**Type:** `string`<br/>**Default:** `"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4cvZ01fLmO9cJbWUj7sfF+NhECgy+Cl0bazSrZX7sU vault-ca@vault.operations.giantswarm.io"`|

### Control plane
Properties within the `.controlPlane` top-level object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `controlPlane.etcdVolumeSizeGB` | **Etcd volume size (GB)**|**Type:** `integer`<br/>**Default:** `10`|
| `controlPlane.instanceType` | **Node VM size**|**Type:** `string`<br/>**Default:** `"Standard_D4s_v3"`|
| `controlPlane.oidc` | **OIDC authentication**|**Type:** `object`<br/>|
| `controlPlane.oidc.caPem` | **Certificate authority** - Identity provider's CA certificate in PEM format.|**Type:** `string`<br/>**Default:** `""`|
| `controlPlane.oidc.clientId` | **Client ID**|**Type:** `string`<br/>**Default:** `""`|
| `controlPlane.oidc.groupsClaim` | **Groups claim**|**Type:** `string`<br/>**Default:** `""`|
| `controlPlane.oidc.issuerUrl` | **Issuer URL**|**Type:** `string`<br/>**Default:** `""`|
| `controlPlane.oidc.usernameClaim` | **Username claim**|**Type:** `string`<br/>**Default:** `""`|
| `controlPlane.replicas` | **Number of nodes**|**Type:** `integer`<br/>**Default:** `3`|
| `controlPlane.rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Default:** `50`|

### Internal settings
Properties within the `.internal` top-level object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `internal.defaults` | **Default settings**|**Type:** `object`<br/>|
| `internal.defaults.evictionMinimumReclaim` | **Default settings for eviction minimum reclaim**|**Type:** `string`<br/>**Default:** `"imagefs.available=5%,memory.available=100Mi,nodefs.available=5%"`|
| `internal.defaults.hardEvictionThresholds` | **Default settings for hard eviction thresholds**|**Type:** `string`<br/>**Default:** `"memory.available\u003c200Mi,nodefs.available\u003c10%,nodefs.inodesFree\u003c3%,imagefs.available\u003c10%,pid.available\u003c20%"`|
| `internal.defaults.softEvictionGracePeriod` | **Default settings for soft eviction grace period**|**Type:** `string`<br/>**Default:** `"memory.available=30s,nodefs.available=2m,nodefs.inodesFree=1m,imagefs.available=2m,pid.available=1m"`|
| `internal.defaults.softEvictionThresholds` | **Default settings for soft eviction thresholds**|**Type:** `string`<br/>**Default:** `"memory.available\u003c500Mi,nodefs.available\u003c15%,nodefs.inodesFree\u003c5%,imagefs.available\u003c15%,pid.available\u003c30%"`|
| `internal.identity` | **Identity**|**Type:** `object`<br/>|
| `internal.identity.attachCapzControllerUserAssignedIdentity` | **Attach CAPZ controller UserAssigned identity**|**Type:** `boolean`<br/>**Default:** `false`|
| `internal.identity.systemAssignedScope` | **Scope of SystemAssignedIdentity**|**Type:** `string`<br/>**Default:** `"ResourceGroup"`|
| `internal.identity.type` | **Type of Identity**|**Type:** `string`<br/>**Default:** `"SystemAssigned"`|
| `internal.identity.userAssignedCustomIdentities` | **List of custom UserAssigned Identities to attach to all nodes**|**Type:** `array`<br/>**Default:** `[]`|
| `internal.image` | **Node Image**|**Type:** `object`<br/>|
| `internal.image.gallery` | **Gallery** - Name of the community gallery hosting the image|**Type:** `string`<br/>**Default:** `"gsCapzFlatcar-41c2d140-ac44-4d8b-b7e1-7b2f1ddbe4d0"`|
| `internal.image.name` | **Image Definition** - Name of the image definition in the Gallery|**Type:** `string`<br/>**Default:** `""`|
| `internal.image.version` | **Image version**|**Type:** `string`<br/>**Default:** `"3510.2.1"`|
| `internal.kubernetesVersion` | **Kubernetes version**|**Type:** `string`<br/>**Default:** `"1.24.13"`|
| `internal.network` | **Network configuration** - Internal network configuration that is susceptible to more frequent change|**Type:** `object`<br/>|
| `internal.network.subnets` | **VNet spec** - Customize subnets configuration|**Type:** `object`<br/>**Default:** `{}`|
| `internal.network.subnets.controlPlaneSubnetName` | **ControlPlane subnet name** - Name of the control plane subnet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `internal.network.subnets.nodeSubnetNatGatewayName` | **Nodes subnet nat-gateway name** - Name of the nat gateway on the nodes subnet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `internal.network.subnets.nodesSubnetName` | **Nodes subnet name** - Name of the nodes subnet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `internal.network.vnet` | **VNet spec** - Existing VNet configuration. This is susceptible to more frequent change or removal.|**Type:** `object`<br/>**Default:** `{}`|
| `internal.network.vnet.name` | **VNet name** - Name of the existing VNet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `internal.network.vnet.resourceGroup` | **Resource group name** - Resource group where the existing VNet is deployed.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._\(\)]+$`<br/>|
| `internal.network.vpn` | **VPN configuration** - Internal VPN configuration that is susceptible to more frequent change|**Type:** `object`<br/>|
| `internal.network.vpn.gatewayMode` | **VPN gateway mode**|**Type:** `string`<br/>**Default:** `"none"`|
| `internal.sandboxContainerImage` | **Kubectl image**|**Type:** `object`<br/>|
| `internal.sandboxContainerImage.name` | **Repository**|**Type:** `string`<br/>**Default:** `"giantswarm/pause"`|
| `internal.sandboxContainerImage.registry` | **Registry**|**Type:** `string`<br/>**Default:** `"quay.io"`|
| `internal.sandboxContainerImage.tag` | **Tag**|**Type:** `string`<br/>**Default:** `"3.9"`|

### Metadata
Properties within the `.metadata` top-level object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `metadata.description` | **Cluster description** - User-friendly description of the cluster's purpose.|**Type:** `string`<br/>|
| `metadata.labels` | **Labels** - These labels are added to the Kubernetes resourses defining this cluster.|**Type:** `object`<br/>|
| `metadata.labels.PATTERN` | **Label**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-zA-Z0-9/\._-]+$`<br/>**Value pattern:** `^[a-zA-Z0-9\._-]+$`<br/>|
| `metadata.name` | **Cluster name** - Unique identifier, cannot be changed after creation.|**Type:** `string`<br/>|
| `metadata.organization` | **Organization**|**Type:** `string`<br/>|
| `metadata.servicePriority` | **Service priority** - The relative importance of this cluster.|**Type:** `string`<br/>**Default:** `"highest"`|

### Node pools
Properties within the `.nodePools` top-level object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `nodePools[*].customNodeLabels` | **Custom node labels**|**Type:** `array`<br/>|
| `nodePools[*].customNodeLabels[*]` | **Label**|**Type:** `string`<br/>|
| `nodePools[*].customNodeTaints` | **Custom node taints**|**Type:** `array`<br/>|
| `nodePools[*].customNodeTaints[*]` | **Node taint**|**Type:** `object`<br/>|
| `nodePools[*].customNodeTaints[*].effect` | **Effect**|**Type:** `string`<br/>|
| `nodePools[*].customNodeTaints[*].key` | **Key**|**Type:** `string`<br/>|
| `nodePools[*].customNodeTaints[*].value` | **Value**|**Type:** `string`<br/>|
| `nodePools[*].disableHealthCheck` | **Disable HealthChecks for the MachineDeployment**|**Type:** `boolean`<br/>|
| `nodePools[*].failureDomain` | **Availability zone**|**Type:** `string`<br/>|
| `nodePools[*].instanceType` | **VM size**|**Type:** `string`<br/>|
| `nodePools[*].name` | **Name** - Unique identifier, cannot be changed after creation.|**Type:** `string`<br/>|
| `nodePools[*].replicas` | **Number of nodes**|**Type:** `integer`<br/>|
| `nodePools[*].rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>|

### Other

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `baseDomain` | **Base DNS domain**|**Type:** `string`<br/>**Default:** `"azuretest.gigantic.io"`|
| `cluster-shared` | **Library chart**|**Type:** `object`<br/>|
| `managementCluster` | **The capi MC managing this cluster**|**Type:** `string`<br/>|
| `provider` | **Cluster API provider name**|**Type:** `string`<br/>|



<!-- DOCS_END -->
