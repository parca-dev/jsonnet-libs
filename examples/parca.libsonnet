local scrapeConfigs = import '../scrape-configs/scrape-configs.libsonnet';
local pa = import 'github.com/parca-dev/parca-agent/deploy/lib/parca-agent/parca-agent.libsonnet';
local p = import 'github.com/parca-dev/parca/deploy/lib/parca/parca.libsonnet';

local parcaConfig = {
  namespace: 'parca',
  version: 'dev',
  image: 'ghcr.io/parca-dev/parca:' + self.version,
  replicas: 1,
  podProfilers: [
    {
      name: 'parca-agent',
      namespace: $.namespace,
      podProfileEndpoints: [{
        port: 'http',
        relabelings: [
          {
            source_labels: ['__meta_kubernetes_pod_node_name'],
            target_label: 'instance',
          },
          {
            source_labels: ['__meta_kubernetes_service_label_app_kubernetes_io_version'],
            target_label: 'version',
          },
        ],
      }],
      selector: {
        matchLabels: {
          'app.kubernetes.io/name': 'parca-agent',
          'app.kubernetes.io/instance': 'parca-agent',
          'app.kubernetes.io/component': 'observability',
        },
      },
    },
  ],
  serviceProfilers: [
    {
      name: $.name,
      namespace: $.namespace,
      endpoints: [{
        port: 'http',
        profilingConfig: {
          pprof_config: {
            fgprof: {
              enabled: true,
              path: '/debug/pprof/fgprof',
            },
          },
        },
        relabelings: [
          {
            source_labels: ['namespace', 'pod'],
            separator: '/',
            target_label: 'instance',
          },
          {
            source_labels: ['__meta_kubernetes_pod_label_app_kubernetes_io_version'],
            target_label: 'version',
          },
        ],
      }],
      selector: {
        matchLabels: $.podLabelSelector,
      },
    },
  ],
  config+:
    scrapeConfigs.generatePodProfilersConfig($.podProfilers) +
    scrapeConfigs.generateServiceProfilersConfig($.serviceProfilers),
};

local parcaAgentConfig = {
  namespace: 'parca',
  version: 'dev',
  image: 'ghcr.io/parca-dev/parca-agent:' + self.version,
};

local parca = p(parcaConfig) {
  clusterRole: {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRole',
    metadata: {
      name: $.config.name,
      namespace: $.config.namespace,
      labels: $.config.commonLabels,
    },
    rules: [
      {
        apiGroups: [''],
        resources: ['services', 'endpoints', 'pods'],
        verbs: ['get', 'list', 'watch'],
      },
      {
        apiGroups: ['networking.k8s.io'],
        resources: ['ingresses'],
        verbs: ['get', 'list', 'watch'],
      },
    ],
  },

  clusterRoleBinding: {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      name: $.config.name,
      namespace: $.config.namespace,
      labels: $.config.commonLabels,
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: $.config.name,
    },
    subjects: [{
      kind: 'ServiceAccount',
      name: $.config.name,
      namespace: $.config.namespace,
    }],
  },
};

local parcaAgent = pa(parcaAgentConfig);

{
  kind: 'List',
  apiVersion: 'v1',
  items:
    [parca[name] for name in std.objectFields(parca) if parca[name] != null] +
    [parcaAgent[name] for name in std.objectFields(parcaAgent) if parcaAgent[name] != null],
}
