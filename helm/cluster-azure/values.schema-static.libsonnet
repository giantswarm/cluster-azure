{
  description: 'Configuration of an Azure cluster using Cluster API',
  properties+: {
    attachCapzControllerIdentity+: {
      title: 'Attach controller identity',
    },
    azure+: {
      properties+: {
        azureClusterIdentity+: {
          description: 'AzureClusterIdentity resource to use for this cluster.',
          properties+: {
            name+: {
              title: 'Name',
            },
            namespace+: {
              title: 'Namespace',
            },
          },
          title: 'Identity',
        },
        location+: {
          title: 'Location',
        },
        subscriptionId+: {
          title: 'Subscription ID',
        },
      },
      title: 'Azure settings',
    },
    clusterDescription+: {
      description: "User-friendly description of the cluster's purpose.",
      title: 'Cluster description',
    },
    clusterName+: {
      description: 'Unique identifier, cannot be changed after creation.',
      title: 'Cluster name',
    },
    controlPlane+: {
      properties+: {
        etcdVolumeSizeGB+: {
          title: 'Etcd volume size (GB)',
        },
        instanceType+: {
          title: 'Node VM size',
        },
        replicas+: {
          title: 'Number of nodes',
        },
        rootVolumeSizeGB+: {
          title: 'Root volume size (GB)',
        },
      },
      title: 'Control plane settings',
    },
    defaults+: {
      properties+: {
        evictionMinimumReclaim+: {
          title: 'Default settings for eviction minimum reclaim',
        },
        hardEvictionThresholds+: {
          title: 'Default settings for hard eviction thresholds',
        },
        softEvictionGracePeriod+: {
          title: 'Default settings for soft eviction grace period',
        },
        softEvictionThresholds+: {
          title: 'Default settings for soft eviction thresholds',
        },
      },
    },
    enablePerClusterIdentity+: {
      title: 'Enable identity per cluster',
    },
    includeClusterResourceSet+: {
    },
    kubernetesVersion+: {
      title: 'Kubernetes version',
    },
    machineDeployments+: {
      items+: {
        properties+: {
          customNodeLabels+: {
            items+: {
              title: 'Label',
              type: 'string',
            },
            title: 'Custom node labels',
          },
          customNodeTaints+: {
            descriptions: 'Taints that will be set on all nodes in the node pool, to avoid the scheduling of certain workloads.',
            items+: {
              properties+: {
                effect+: {
                  enum: [
                    'NoSchedule',
                    'PreferNoSchedule',
                    'NoExecute',
                  ],
                  title: 'Effect',
                  type: 'string',
                },
                key+: {
                  title: 'Key',
                  type: 'string',
                },
                value+: {
                  title: 'Value',
                  type: 'string',
                },
              },
              required+: [
                'effect',
                'key',
                'value',
              ],
              type: 'object',
              title: 'Node taint',
            },
            title: 'Custom node taints',
          },
          disableHealthCheck+: {
            title: 'Disable HealthChecks for the MachineDeployment',
          },
          instanceType+: {
            title: 'VM size',
          },
          name+: {
            description: 'Unique identifier, cannot be changed after creation.',
            title: 'Name',
          },
          replicas+: {
            title: 'Number of nodes in the MachineDeployment',
          },
          rootVolumeSizeGB+: {
            title: 'Root volume size (GB)',
          },
        },
        title: 'Node pool',
      },
      title: 'Node pools',
    },
    machinePools+: {
    },
    network+: {
      properties+: {
        hostCIDR+: {
          title: 'Host CIDR',
        },
        podCIDR+: {
          title: 'Pod CIDR',
        },
        serviceCIDR+: {
          title: 'Service CIDR',
        },
      },
      title: 'Network settings',
    },
    oidc+: {
      properties+: {
        caPem+: {
          description: "Identity provider's CA certificate in PEM format.",
          title: 'Certificate authority',
        },
        clientId+: {
          title: 'Client ID',
        },
        groupsClaim+: {
          title: 'Groups claim',
        },
        issuerUrl+: {
          title: 'Issuer URL',
        },
        usernameClaim+: {
          title: 'Username claim',
        },
      },
      title: 'OIDC settings',
    },
    organization+: {
      title: 'Organization',
    },
    sshSSOPublicKey+: {
      title: 'SSH Public key for SSO',
    },
  },
  title: 'Cluster configuration',
}
