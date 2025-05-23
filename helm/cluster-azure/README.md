# Values schema documentation

This page lists all available configuration options, based on the [configuration values schema](values.schema.json).

Note that configuration options can change between releases. Use the GitHub function for selecting a branch/tag to view the documentation matching your cluster-azure version.

<!-- Update the content below by executing (from the repo root directory)

schemadocs generate helm/cluster-azure/values.schema.json -o helm/cluster-azure/README.md

-->

<!-- DOCS_START -->

### Apps
Properties within the `.global.apps` object
Configuration of apps that are part of the cluster.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.apps.azureCloudControllerManager` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.azureCloudControllerManager.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.azureCloudControllerManager.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.azureCloudControllerManager.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.azureCloudControllerManager.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.azureCloudControllerManager.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.azureCloudControllerManager.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.azureCloudNodeManager` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.azureCloudNodeManager.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.azureCloudNodeManager.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.azureCloudNodeManager.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.azureCloudNodeManager.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.azureCloudNodeManager.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.azureCloudNodeManager.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.azureDiskCsiDriver` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.azureDiskCsiDriver.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.azureDiskCsiDriver.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.azureDiskCsiDriver.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.azureDiskCsiDriver.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.azureDiskCsiDriver.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.azureDiskCsiDriver.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.azureFileCsiDriver` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.azureFileCsiDriver.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.azureFileCsiDriver.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.azureFileCsiDriver.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.azureFileCsiDriver.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.azureFileCsiDriver.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.azureFileCsiDriver.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.capiNodeLabeler` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.capiNodeLabeler.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.capiNodeLabeler.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.capiNodeLabeler.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.capiNodeLabeler.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.capiNodeLabeler.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.capiNodeLabeler.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.certExporter` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.certExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.certExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.certExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.certExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.certExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.certExporter.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.certManager` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.certManager.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.certManager.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.certManager.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.certManager.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.certManager.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.certManager.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.chartOperatorExtensions` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.chartOperatorExtensions.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.chartOperatorExtensions.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.cilium` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.cilium.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.cilium.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.cilium.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.cilium.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.cilium.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.cilium.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.ciliumServiceMonitors` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.ciliumServiceMonitors.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.ciliumServiceMonitors.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.clusterAutoscaler` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.clusterAutoscaler.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.clusterAutoscaler.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.coreDns` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.coreDns.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.coreDns.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.coreDns.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.coreDns.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.coreDns.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.coreDns.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.etcdKubernetesResourcesCountExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.etcdKubernetesResourcesCountExporter.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.externalDns` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.externalDns.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.externalDns.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.externalDns.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.externalDns.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.externalDns.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.externalDns.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.externalDnsPrivate` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.externalDnsPrivate.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.externalDnsPrivate.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.externalDnsPrivate.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.externalDnsPrivate.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.externalDnsPrivate.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.externalDnsPrivate.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.k8sAuditMetrics` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.k8sAuditMetrics.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.k8sAuditMetrics.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.k8sDnsNodeCache` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.k8sDnsNodeCache.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.k8sDnsNodeCache.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.metricsServer` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.metricsServer.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.metricsServer.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.metricsServer.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.metricsServer.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.metricsServer.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.metricsServer.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.netExporter` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.netExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.netExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.netExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.netExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.netExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.netExporter.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.networkPolicies` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.networkPolicies.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.networkPolicies.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.networkPolicies.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.networkPolicies.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.networkPolicies.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.networkPolicies.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.nodeExporter` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.nodeExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.nodeExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.nodeExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.nodeExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.nodeExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.nodeExporter.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.observabilityBundle` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.observabilityBundle.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.observabilityBundle.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.observabilityBundle.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.observabilityBundle.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.observabilityBundle.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.observabilityBundle.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.observabilityPolicies` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.observabilityPolicies.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.observabilityPolicies.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.observabilityPolicies.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.observabilityPolicies.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.observabilityPolicies.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.observabilityPolicies.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.prometheusBlackboxExporter` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.prometheusBlackboxExporter.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.prometheusBlackboxExporter.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.securityBundle` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.securityBundle.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.securityBundle.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.securityBundle.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.securityBundle.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.securityBundle.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.securityBundle.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.teleportKubeAgent` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.teleportKubeAgent.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.teleportKubeAgent.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscaler` | **App** - Configuration of an default app that is part of the cluster.|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.verticalPodAutoscaler.extraConfigs[*].priority` | **Priority**|**Type:** `integer`<br/>**Default:** `25`|
| `global.apps.verticalPodAutoscaler.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscalerCrd` | **App** - Configuration of a default app that is part of the cluster and is deployed as a HelmRelease resource.|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs` | **Extra config maps or secrets** - Extra config maps or secrets that will be used to customize to the app. The desired values must be under configmap or secret key 'values'. The values are merged in the order given, with the later values overwriting earlier, and then inline values overwriting those. Resources must be in the same namespace as the cluster.|**Type:** `array`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs[*]` | **Config map or secret**|**Type:** `object`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs[*].kind` | **Kind** - Specifies whether the resource is a config map or a secret.|**Type:** `string`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs[*].name` | **Name** - Name of the config map or secret. The object must exist in the same namespace as the cluster App.|**Type:** `string`<br/>|
| `global.apps.verticalPodAutoscalerCrd.extraConfigs[*].optional` | **Optional** - Optional marks this ValuesReference as optional. When set, a not found error for the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.|**Type:** `boolean`<br/>|
| `global.apps.verticalPodAutoscalerCrd.values` | **Values** - Values to be passed to the app. Values will have higher priority than values from configmaps.|**Type:** `object`<br/>|

### Azure settings
Properties within the `.global.providerSpecific` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.providerSpecific.additionalResourceTags` | **Additional resource tags** - Additional tags to be added to the resource group and to all resources in it.|**Type:** `object`<br/>**Default:** `{}`|
| `global.providerSpecific.additionalResourceTags.*` | **Tag value** - Value of the tag|**Type:** `string`<br/>|
| `global.providerSpecific.allowedSubscriptions` | **List of Azure Subscription IDs that are allowed to work on this cluster**|**Type:** `array`<br/>**Default:** `[]`|
| `global.providerSpecific.allowedSubscriptions[*]` | **Azure Subscription ID**|**Type:** `string`<br/>**Example:** `"291bba3f-e0a5-47bc-a099-3bdcb2a50a05"`<br/>**Value pattern:** `^[a-fA-F0-9][-a-fA-F0-9]+[a-fA-F0-9]$`<br/>|
| `global.providerSpecific.azureClusterIdentity` | **Identity** - AzureClusterIdentity resource to use for this cluster.|**Type:** `object`<br/>|
| `global.providerSpecific.azureClusterIdentity.name` | **Name**|**Type:** `string`<br/>**Default:** `"cluster-identity"`|
| `global.providerSpecific.azureClusterIdentity.namespace` | **Namespace**|**Type:** `string`<br/>**Default:** `"org-giantswarm"`|
| `global.providerSpecific.identity` | **Identity**|**Type:** `object`<br/>|
| `global.providerSpecific.identity.systemAssignedScope` | **Scope of SystemAssignedIdentity**|**Type:** `string`<br/>**Default:** `"ResourceGroup"`|
| `global.providerSpecific.identityClientID` | **Identity Client ID** - Identity Client ID - only necessary for management clusters.|**Type:** `string`<br/>|
| `global.providerSpecific.location` | **Location**|**Type:** `string`<br/>**Default:** `"westeurope"`|
| `global.providerSpecific.network` | **Azure network settings** - Azure VNet peering and other Azure-specific network settings.|**Type:** `object`<br/>|
| `global.providerSpecific.network.peerings` | **VNet peerings** - Specifying VNets (their resource groups and names) to which the peering is established.|**Type:** `array`<br/>**Default:** `[]`|
| `global.providerSpecific.network.peerings[*]` | **VNet peering**|**Type:** `object`<br/>|
| `global.providerSpecific.network.peerings[*].remoteVnetName` | **VNet name** - Name of the remote VNet to which the peering is established.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `global.providerSpecific.network.peerings[*].resourceGroup` | **Resource group name** - Resource group for the remote VNet to which the peering is established.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._\(\)]+$`<br/>|
| `global.providerSpecific.subscriptionId` | **Azure Subscription ID**|**Type:** `string`<br/>**Example:** `"291bba3f-e0a5-47bc-a099-3bdcb2a50a05"`<br/>**Value pattern:** `^[a-fA-F0-9][-a-fA-F0-9]+[a-fA-F0-9]$`<br/>|

### Components
Properties within the `.global.components` object
Advanced configuration of components that are running on all nodes.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.components.auditd` | **Auditd** - Enable Auditd service.|**Type:** `object`<br/>|
| `global.components.auditd.enabled` | **Enabled** - Whether or not the Auditd service shall be enabled. When true, the Auditd service is enabled. When false, the Auditd service is disabled.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.components.containerd` | **Containerd** - Configuration of containerd.|**Type:** `object`<br/>|
| `global.components.containerd.containerRegistries` | **Container registries** - Endpoints and credentials configuration for container registries.|**Type:** `object`<br/>**Default:** `{"docker.io":[{"endpoint":"registry-1.docker.io"},{"endpoint":"giantswarm.azurecr.io"}],"gsoci.azurecr.io":[{"endpoint":"gsoci.azurecr.io"}]}`|
| `global.components.containerd.containerRegistries.*` | **Registries** - Container registries and mirrors|**Type:** `array`<br/>|
| `global.components.containerd.containerRegistries.*[*]` | **Registry**|**Type:** `object`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials` | **Credentials**|**Type:** `object`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials.auth` | **Auth** - Base64-encoded string from the concatenation of the username, a colon, and the password.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials.identitytoken` | **Identity token** - Used to authenticate the user and obtain an access token for the registry.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials.password` | **Password** - Used to authenticate for the registry with username/password.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries.*[*].credentials.username` | **Username** - Used to authenticate for the registry with username/password.|**Type:** `string`<br/>|
| `global.components.containerd.containerRegistries.*[*].endpoint` | **Endpoint** - Endpoint for the container registry.|**Type:** `string`<br/>|
| `global.components.containerd.localRegistryCache` | **Local registry caches configuration** - Enable local cache via http://127.0.0.1:<PORT>.|**Type:** `object`<br/>|
| `global.components.containerd.localRegistryCache.enabled` | **Enable local registry caches** - Flag to enable local registry cache.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.components.containerd.localRegistryCache.mirroredRegistries` | **Registries to cache locally** - A list of registries that should be cached.|**Type:** `array`<br/>**Default:** `[]`|
| `global.components.containerd.localRegistryCache.mirroredRegistries[*]` |**None**|**Type:** `string`<br/>|
| `global.components.containerd.localRegistryCache.port` | **Local port for the registry cache** - Port for the local registry cache under: http://127.0.0.1:<PORT>.|**Type:** `integer`<br/>**Default:** `32767`|
| `global.components.containerd.managementClusterRegistryCache` | **Management cluster registry cache** - Caching container registry on a management cluster level.|**Type:** `object`<br/>|
| `global.components.containerd.managementClusterRegistryCache.enabled` | **Enabled** - Enabling this will configure containerd to use management cluster's Zot registry service. To make use of it as a pull-through cache, you also have to specify registries to cache images for.|**Type:** `boolean`<br/>**Default:** `true`|
| `global.components.containerd.managementClusterRegistryCache.mirroredRegistries` | **Registries to cache** - Here you must specify each registry to cache container images for. Please also make sure to have an entry for each registry in Global > Components > Containerd > Container registries.|**Type:** `array`<br/>**Default:** `["gsoci.azurecr.io"]`|
| `global.components.containerd.managementClusterRegistryCache.mirroredRegistries[*]` |**None**|**Type:** `string`<br/>|

### Connectivity
Properties within the `.global.connectivity` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.connectivity.allowedCIDRs` | **List of CIDRs which have to been allowed to connect to the API Server endpoint**|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.allowedCIDRs[*]` |**None**|**Type:** `string`<br/>|
| `global.connectivity.baseDomain` | **Base DNS domain**|**Type:** `string`<br/>**Default:** `"azuretest.gigantic.io"`|
| `global.connectivity.network` | **Network**|**Type:** `object`<br/>|
| `global.connectivity.network.controlPlane` | **Control plane**|**Type:** `object`<br/>|
| `global.connectivity.network.controlPlane.cidr` | **Subnet**|**Type:** `string`<br/>**Default:** `"10.0.0.0/20"`|
| `global.connectivity.network.controlPlane.privateEndpoints` | **Private endpoints**|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.controlPlane.privateEndpoints[*]` | **Private endpoint**|**Type:** `object`<br/>|
| `global.connectivity.network.controlPlane.privateEndpoints[*].applicationSecurityGroups` | **Application security groups** - ApplicationSecurityGroups specifies the Application security group in which the private endpoint IP configuration is included.|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.controlPlane.privateEndpoints[*].applicationSecurityGroups[*]` | **Application security group**|**Type:** `string`<br/>|
| `global.connectivity.network.controlPlane.privateEndpoints[*].customNetworkInterfaceName` | **Custom network interface name** - CustomNetworkInterfaceName specifies the network interface name associated with the private endpoint.|**Type:** `string`<br/>**Default:** `""`|
| `global.connectivity.network.controlPlane.privateEndpoints[*].manualApproval` | **Manual approval** - ManualApproval specifies if the connection approval needs to be done manually or not. Set it true when the network admin does not have access to approve connections to the remote resource.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.connectivity.network.controlPlane.privateEndpoints[*].name` | **Name of the private endpoint (must be unique in the resource group)**|**Type:** `string`<br/>**Default:** `""`|
| `global.connectivity.network.controlPlane.privateEndpoints[*].privateIPAddresses` | **Private IP addresses** - PrivateIPAddresses specifies the IP addresses for the network interface associated with the private endpoint. They have to be part of the subnet where the private endpoint is linked.|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.controlPlane.privateEndpoints[*].privateIPAddresses[*]` | **Private IP address**|**Type:** `string`<br/>|
| `global.connectivity.network.controlPlane.privateEndpoints[*].privateLinkServiceConnections` | **Private link service IDs**|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.controlPlane.privateEndpoints[*].privateLinkServiceConnections[*]` | **Private link service definition**|**Type:** `object`<br/>|
| `global.connectivity.network.controlPlane.privateEndpoints[*].privateLinkServiceConnections[*].groupIDs` | **Group IDs** - GroupIDs specifies the ID(s) of the group(s) obtained from the remote resource that this private endpoint should connect to.|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.controlPlane.privateEndpoints[*].privateLinkServiceConnections[*].groupIDs[*]` | **Group ID**|**Type:** `string`<br/>**Example:** `"blob"`<br/>|
| `global.connectivity.network.controlPlane.privateEndpoints[*].privateLinkServiceConnections[*].name` | **Name** - Name specifies the name of the private link service.|**Type:** `string`<br/>**Default:** `""`|
| `global.connectivity.network.controlPlane.privateEndpoints[*].privateLinkServiceConnections[*].privateLinkServiceID` | **The private link service ID**|**Type:** `string`<br/>**Examples:** `"/subscriptions/12345678-9abc-def0-1234-567890abcdef/resourceGroups/rg1/providers/Microsoft.Network/privateLinkServices/privatelink1", "/subscriptions/12345678-9abc-def0-1234-567890abcdef/resourceGroups/rg2/providers/Microsoft.Storage/storageAccounts/bucket1"`<br/>**Value pattern:** `^/subscriptions/[a-fA-F0-9][-a-fA-F0-9]+[a-fA-F0-9]/resourceGroups/[^/]+/providers/[^/]+/[^/]+/.+$`<br/>|
| `global.connectivity.network.controlPlane.privateEndpoints[*].privateLinkServiceConnections[*].requestMessage` | **Request message** - RequestMessage specifies a message passed to the owner of the remote resource with the private endpoint connection request.|**Type:** `string`<br/>**Default:** `""`|
| `global.connectivity.network.controlPlane.routeTableName` | **ControlPlane route table name** - Name of the control plane route table.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `global.connectivity.network.controlPlane.subnetName` | **ControlPlane subnet name** - Name of the control plane subnet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `global.connectivity.network.hostCidr` | **Node subnet** - IPv4 address range for nodes, in CIDR notation.|**Type:** `string`<br/>**Default:** `"10.0.0.0/16"`|
| `global.connectivity.network.mode` | **Network mode** - Specifying if the cluster resources are publicly accessible or not.|**Type:** `string`<br/>**Default:** `"public"`|
| `global.connectivity.network.pods` | **Pods**|**Type:** `object`<br/>|
| `global.connectivity.network.pods.cidrBlocks` | **Pod subnets**|**Type:** `array`<br/>**Default:** `["192.168.0.0/16"]`|
| `global.connectivity.network.pods.cidrBlocks[*]` | **Pod subnet** - IPv4 address range for pods, in CIDR notation.|**Type:** `string`<br/>**Example:** `"192.168.0.0/16"`<br/>|
| `global.connectivity.network.pods.nodeCidrMaskSize` | **Node CIDR mask size** - The size of the mask that is used for the node CIDR. The node CIDR is a sub-range of the pod CIDR and so the mask size and pod CIDR must be chosen such that there is enough space for the maximum number of nodes in the cluster.|**Type:** `integer`<br/>**Default:** `24`|
| `global.connectivity.network.services` | **Services**|**Type:** `object`<br/>|
| `global.connectivity.network.services.cidrBlocks` | **K8s Service subnets**|**Type:** `array`<br/>**Default:** `["172.31.0.0/16"]`|
| `global.connectivity.network.services.cidrBlocks[*]` | **Service subnet** - IPv4 address range for kubernetes services, in CIDR notation.|**Type:** `string`<br/>**Example:** `"172.31.0.0/16"`<br/>|
| `global.connectivity.network.workers` | **Workers**|**Type:** `object`<br/>|
| `global.connectivity.network.workers.cidr` | **Subnet**|**Type:** `string`<br/>**Default:** `"10.0.16.0/20"`|
| `global.connectivity.network.workers.natGatewayName` | **Nodes subnet nat-gateway name** - Name of the nat gateway on the nodes subnet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `global.connectivity.network.workers.privateEndpoints` | **Private endpoints**|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.workers.privateEndpoints[*]` | **Private endpoint**|**Type:** `object`<br/>|
| `global.connectivity.network.workers.privateEndpoints[*].applicationSecurityGroups` | **Application security groups** - ApplicationSecurityGroups specifies the Application security group in which the private endpoint IP configuration is included.|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.workers.privateEndpoints[*].applicationSecurityGroups[*]` | **Application security group**|**Type:** `string`<br/>|
| `global.connectivity.network.workers.privateEndpoints[*].customNetworkInterfaceName` | **Custom network interface name** - CustomNetworkInterfaceName specifies the network interface name associated with the private endpoint.|**Type:** `string`<br/>**Default:** `""`|
| `global.connectivity.network.workers.privateEndpoints[*].manualApproval` | **Manual approval** - ManualApproval specifies if the connection approval needs to be done manually or not. Set it true when the network admin does not have access to approve connections to the remote resource.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.connectivity.network.workers.privateEndpoints[*].name` | **Name of the private endpoint (must be unique in the resource group)**|**Type:** `string`<br/>**Default:** `""`|
| `global.connectivity.network.workers.privateEndpoints[*].privateIPAddresses` | **Private IP addresses** - PrivateIPAddresses specifies the IP addresses for the network interface associated with the private endpoint. They have to be part of the subnet where the private endpoint is linked.|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.workers.privateEndpoints[*].privateIPAddresses[*]` | **Private IP address**|**Type:** `string`<br/>|
| `global.connectivity.network.workers.privateEndpoints[*].privateLinkServiceConnections` | **Private link service IDs**|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.workers.privateEndpoints[*].privateLinkServiceConnections[*]` | **Private link service definition**|**Type:** `object`<br/>|
| `global.connectivity.network.workers.privateEndpoints[*].privateLinkServiceConnections[*].groupIDs` | **Group IDs** - GroupIDs specifies the ID(s) of the group(s) obtained from the remote resource that this private endpoint should connect to.|**Type:** `array`<br/>**Default:** `[]`|
| `global.connectivity.network.workers.privateEndpoints[*].privateLinkServiceConnections[*].groupIDs[*]` | **Group ID**|**Type:** `string`<br/>**Example:** `"blob"`<br/>|
| `global.connectivity.network.workers.privateEndpoints[*].privateLinkServiceConnections[*].name` | **Name** - Name specifies the name of the private link service.|**Type:** `string`<br/>**Default:** `""`|
| `global.connectivity.network.workers.privateEndpoints[*].privateLinkServiceConnections[*].privateLinkServiceID` | **The private link service ID**|**Type:** `string`<br/>**Examples:** `"/subscriptions/12345678-9abc-def0-1234-567890abcdef/resourceGroups/rg1/providers/Microsoft.Network/privateLinkServices/privatelink1", "/subscriptions/12345678-9abc-def0-1234-567890abcdef/resourceGroups/rg2/providers/Microsoft.Storage/storageAccounts/bucket1"`<br/>**Value pattern:** `^/subscriptions/[a-fA-F0-9][-a-fA-F0-9]+[a-fA-F0-9]/resourceGroups/[^/]+/providers/[^/]+/[^/]+/.+$`<br/>|
| `global.connectivity.network.workers.privateEndpoints[*].privateLinkServiceConnections[*].requestMessage` | **Request message** - RequestMessage specifies a message passed to the owner of the remote resource with the private endpoint connection request.|**Type:** `string`<br/>**Default:** `""`|
| `global.connectivity.network.workers.routeTableName` | **Nodes route table name** - Name of the nodes route table.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `global.connectivity.network.workers.subnetName` | **Nodes subnet name** - Name of the nodes subnet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|

### Control plane
Properties within the `.global.controlPlane` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.controlPlane.containerdVolumeSizeGB` | **Containerd volume size (GB)**|**Type:** `integer`<br/>**Default:** `100`|
| `global.controlPlane.encryptionAtHost` | **Encryption at host** - Enable encryption at host for the control plane nodes.|**Type:** `boolean`<br/>**Default:** `false`|
| `global.controlPlane.etcdVolumeSizeGB` | **Etcd volume size (GB)**|**Type:** `integer`<br/>**Default:** `50`|
| `global.controlPlane.instanceType` | **Node VM size**|**Type:** `string`<br/>**Default:** `"Standard_D4s_v5"`|
| `global.controlPlane.kubeletVolumeSizeGB` | **Kubelet volume size (GB)**|**Type:** `integer`<br/>**Default:** `100`|
| `global.controlPlane.oidc` | **OIDC authentication**|**Type:** `object`<br/>|
| `global.controlPlane.oidc.caPem` | **Certificate authority** - Identity provider's CA certificate in PEM format.|**Type:** `string`<br/>**Default:** `""`|
| `global.controlPlane.oidc.clientId` | **Client ID**|**Type:** `string`<br/>**Default:** `""`|
| `global.controlPlane.oidc.groupsClaim` | **Groups claim**|**Type:** `string`<br/>**Default:** `""`|
| `global.controlPlane.oidc.issuerUrl` | **Issuer URL**|**Type:** `string`<br/>**Default:** `""`|
| `global.controlPlane.oidc.usernameClaim` | **Username claim**|**Type:** `string`<br/>**Default:** `""`|
| `global.controlPlane.replicas` | **Number of nodes**|**Type:** `integer`<br/>**Default:** `3`|
| `global.controlPlane.rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Default:** `50`|

### Internal
Properties within the `.global.internal` object
For Giant Swarm internal use only, not stable, or not supported by UIs.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.internal.hashSalt` | **Hash salt** - If specified, this token is used as a salt to the hash suffix of some resource names. Can be used to force-recreate some resources.|**Type:** `string`<br/>|

### Internal settings
Properties within the `.internal` top-level object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `internal.defaults` | **Default settings**|**Type:** `object`<br/>|
| `internal.defaults.evictionMinimumReclaim` | **Default settings for eviction minimum reclaim**|**Type:** `string`<br/>**Default:** `"imagefs.available=5%,memory.available=100Mi,nodefs.available=5%"`|
| `internal.defaults.hardEvictionThresholds` | **Default settings for hard eviction thresholds**|**Type:** `string`<br/>**Default:** `"memory.available\u003c200Mi,nodefs.available\u003c10%,nodefs.inodesFree\u003c3%,imagefs.available\u003c10%,pid.available\u003c20%"`|
| `internal.defaults.softEvictionGracePeriod` | **Default settings for soft eviction grace period**|**Type:** `string`<br/>**Default:** `"memory.available=30s,nodefs.available=2m,nodefs.inodesFree=1m,imagefs.available=2m,pid.available=1m"`|
| `internal.defaults.softEvictionThresholds` | **Default settings for soft eviction thresholds**|**Type:** `string`<br/>**Default:** `"memory.available\u003c500Mi,nodefs.available\u003c15%,nodefs.inodesFree\u003c5%,imagefs.available\u003c15%,pid.available\u003c30%"`|
| `internal.enableVpaResources` | **Enable VPA Resources in helmreleases**|**Type:** `boolean`<br/>**Default:** `true`|
| `internal.network` | **Network configuration** - Internal network configuration that is susceptible to more frequent change|**Type:** `object`<br/>|
| `internal.network.vnet` | **VNet spec** - Existing VNet configuration. This is susceptible to more frequent change or removal.|**Type:** `object`<br/>**Default:** `{}`|
| `internal.network.vnet.name` | **VNet name** - Name of the existing VNet.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._]+$`<br/>|
| `internal.network.vnet.resourceGroup` | **Resource group name** - Resource group where the existing VNet is deployed.|**Type:** `string`<br/>**Value pattern:** `^[-\w\._\(\)]+$`<br/>|
| `internal.network.vpn` | **VPN configuration** - Internal VPN configuration that is susceptible to more frequent change|**Type:** `object`<br/>|
| `internal.network.vpn.gatewayMode` | **VPN gateway mode**|**Type:** `string`<br/>**Default:** `"none"`|
| `internal.sandboxContainerImage` | **The image used by sandbox / pause container**|**Type:** `object`<br/>|
| `internal.sandboxContainerImage.name` | **Repository**|**Type:** `string`<br/>**Default:** `"giantswarm/pause"`|
| `internal.sandboxContainerImage.registry` | **Registry**|**Type:** `string`<br/>**Default:** `"gsoci.azurecr.io"`|
| `internal.sandboxContainerImage.tag` | **Tag**|**Type:** `string`<br/>**Default:** `"3.9"`|
| `internal.teleport` | **Teleport**|**Type:** `object`<br/>|
| `internal.teleport.enabled` | **Enable teleport**|**Type:** `boolean`<br/>**Default:** `true`|
| `internal.teleport.proxyAddr` | **Teleport proxy address**|**Type:** `string`<br/>**Default:** `"teleport.giantswarm.io:443"`|
| `internal.teleport.version` | **Teleport version**|**Type:** `string`<br/>**Default:** `"14.1.3"`|

### Metadata
Properties within the `.global.metadata` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.metadata.description` | **Cluster description** - User-friendly description of the cluster's purpose.|**Type:** `string`<br/>|
| `global.metadata.labels` | **Labels** - These labels are added to the Kubernetes resources defining this cluster.|**Type:** `object`<br/>|
| `global.metadata.labels.PATTERN` | **Label**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-zA-Z0-9/\._-]+$`<br/>**Value pattern:** `^[a-zA-Z0-9\._-]+$`<br/>|
| `global.metadata.name` | **Cluster name** - Unique identifier, cannot be changed after creation.|**Type:** `string`<br/>|
| `global.metadata.organization` | **Organization**|**Type:** `string`<br/>|
| `global.metadata.preventDeletion` | **Prevent cluster deletion**|**Type:** `boolean`<br/>**Default:** `false`|
| `global.metadata.servicePriority` | **Service priority** - The relative importance of this cluster.|**Type:** `string`<br/>**Default:** `"highest"`|

### Node pools
Properties within the `.global.nodePools` object
Node pools of the cluster. If not specified, this defaults to the value of `cluster.providerIntegration.workers.defaultNodePools`.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.nodePools.PATTERN` | **Node pool**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeLabels` | **Custom node labels**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeLabels[*]` | **Label**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints` | **Custom node taints**|**Type:** `array`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints[*]` |**None**|**Type:** `object`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints[*].effect` | **Effect**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints[*].key` | **Key**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.customNodeTaints[*].value` | **Value**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.encryptionAtHost` | **Encryption at host** - Enable encryption at host for the worker nodes.|**Type:** `boolean`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `false`|
| `global.nodePools.PATTERN.failureDomain` | **Availability zone**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>|
| `global.nodePools.PATTERN.instanceType` | **VM size**|**Type:** `string`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `"Standard_D4s_v5"`|
| `global.nodePools.PATTERN.replicas` | **Number of nodes**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `2`|
| `global.nodePools.PATTERN.rootVolumeSizeGB` | **Root volume size (GB)**|**Type:** `integer`<br/>**Key pattern:**<br/>`PATTERN`=`^[a-z0-9][-a-z0-9]{3,18}[a-z0-9]$`<br/>**Default:** `50`|

### Other global

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.managementCluster` | **The capi MC managing this cluster**|**Type:** `string`<br/>|

### Pod Security Standards
Properties within the `.global.podSecurityStandards` object

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.podSecurityStandards.enforced` | **Enforced Pod Security Standards** - Use PSSs instead of PSPs.|**Type:** `boolean`<br/>**Default:** `true`|

### Release
Properties within the `.global.release` object
Information about the workload cluster release.

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `global.release.version` | **Version**|**Type:** `string`<br/>|

### Other

| **Property** | **Description** | **More Details** |
| :----------- | :-------------- | :--------------- |
| `baseDomain` | **Base DNS domain**|**Type:** `string`<br/>**Default:** `"azuretest.gigantic.io"`|
| `cluster` | **Cluster** - Helm values for the provider-independent cluster chart.|**Type:** `object`<br/>**Default:** `{"internal":{"advancedConfiguration":{"controlPlane":{"etcd":{"dataDir":"/var/lib/etcddisk/etcd"}}}},"providerIntegration":{"apps":{"capiNodeLabeler":{"enable":true},"certExporter":{"enable":true},"certManager":{"configTemplateName":"azureCertManagerHelmValues","enable":true},"chartOperatorExtensions":{"enable":true},"cilium":{"configTemplateName":"azureCiliumHelmValues","enable":true},"ciliumServiceMonitors":{"enable":true},"clusterAutoscaler":{"enable":false},"coreDns":{"configTemplateName":"azureCorednsHelmValues","enable":true},"etcdKubernetesResourcesCountExporter":{"enable":true},"externalDns":{"configTemplateName":"azureExternalDnsHelmValues","enable":true},"k8sAuditMetrics":{"enable":true},"k8sDnsNodeCache":{"enable":true},"metricsServer":{"enable":true},"netExporter":{"enable":true},"networkPolicies":{"configTemplateName":"azureNetworkPoliciesHelmValues","enable":true},"nodeExporter":{"enable":true},"observabilityBundle":{"enable":true},"observabilityPolicies":{"enable":true},"prometheusBlackboxExporter":{"enable":true},"securityBundle":{"configTemplateName":"azureSecurityBundleHelmValues","enable":true},"teleportKubeAgent":{"enable":true},"verticalPodAutoscaler":{"enable":true},"verticalPodAutoscalerCrd":{"enable":true}},"controlPlane":{"kubeadmConfig":{"clusterConfiguration":{"apiServer":{"cloudConfig":"/etc/kubernetes/azure.json"}},"diskSetup":{"filesystems":[{"device":"/dev/disk/azure/scsi1/lun0","extraOpts":["-E","lazy_itable_init=1,lazy_journal_init=1"],"filesystem":"ext4","label":"etcd_disk","overwrite":false},{"device":"/dev/disk/azure/scsi1/lun1","extraOpts":["-E","lazy_itable_init=1,lazy_journal_init=1"],"filesystem":"ext4","label":"containerd_disk","overwrite":false},{"device":"/dev/disk/azure/scsi1/lun2","extraOpts":["-E","lazy_itable_init=1,lazy_journal_init=1"],"filesystem":"ext4","label":"kubelet_disk","overwrite":false}]},"files":[{"contentFrom":{"secret":{"key":"update_etc_hosts.sh","name":"provider-specific-files","prependClusterNameAsPrefix":true}},"path":"/opt/update_etc_hosts.sh","permissions":"0755"}],"ignition":{"containerLinuxConfig":{"additionalConfig":{"storage":{"disks":[{"device":"/dev/disk/azure/scsi1/lun0","partitions":[{"number":1}]}]}}}},"mounts":[["etcd_disk","/var/lib/etcddisk"],["containerd_disk","/var/lib/containerd"],["kubelet_disk","/var/lib/kubelet"]],"postKubeadmCommands":["/opt/update_etc_hosts.sh postKubeadm"],"preKubeadmCommands":["/opt/update_etc_hosts.sh preKubeadm","/bin/test ! -d /var/lib/kubelet \u0026\u0026 (/bin/mkdir -p /var/lib/kubelet \u0026\u0026 /bin/chmod 0750 /var/lib/kubelet)","sed -i -e 's/registry.k8s.io\\/pause/quay.io\\/giantswarm\\/pause/' /etc/sysconfig/kubelet"]},"resources":{"infrastructureMachineTemplate":{"group":"infrastructure.cluster.x-k8s.io","kind":"AzureMachineTemplate","version":"v1beta1"},"infrastructureMachineTemplateSpecTemplateName":"controlplane-azuremachinetemplate-spec"}},"environmentVariables":{"hostName":"HOSTNAME","ipv4":"COREOS_AZURE_IPV4_DYNAMIC"},"osImage":{"channel":"stable","variant":"","version":"3815.2.0"},"provider":"azure","resourcesApi":{"bastionResourceEnabled":false,"cleanupHelmReleaseResourcesEnabled":true,"clusterResourceEnabled":true,"controlPlaneResourceEnabled":true,"coreDnsHelmReleaseResourceEnabled":false,"helmRepositoryResourcesEnabled":true,"infrastructureCluster":{"group":"infrastructure.cluster.x-k8s.io","kind":"AzureCluster","version":"v1beta1"},"infrastructureMachinePool":{"group":"infrastructure.cluster.x-k8s.io","kind":"AzureMachineTemplate","version":"v1beta1"},"machineHealthCheckResourceEnabled":true,"machinePoolResourcesEnabled":true,"nodePoolKind":"MachineDeployment"},"useReleases":true,"workers":{"defaultNodePools":{"def00":{"customNodeLabels":["label=default"],"instanceType":"Standard_D4s_v5","machineHealthCheck":{"enabled":true,"maxUnhealthy":"40%","nodeStartupTimeout":"10m","unhealthyNotReadyTimeout":"300s","unhealthyUnknownTimeout":"300s"},"replicas":2,"rootVolumeSizeGB":50}},"kubeadmConfig":{"preKubeadmCommands":["/bin/test ! -d /var/lib/kubelet \u0026\u0026 (/bin/mkdir -p /var/lib/kubelet \u0026\u0026 /bin/chmod 0750 /var/lib/kubelet)","sed -i -e 's/registry.k8s.io\\/pause/quay.io\\/giantswarm\\/pause/' /etc/sysconfig/kubelet"]},"resources":{"infrastructureMachineTemplateSpecTemplateName":"machinedeployment-azuremachinetemplate-spec"}}}}`|
| `cluster-shared` | **Library chart**|**Type:** `object`<br/>|
| `managementCluster` | **The capi MC managing this cluster**|**Type:** `string`<br/>|
| `provider` | **Cluster API provider name**|**Type:** `string`<br/>|



<!-- DOCS_END -->
