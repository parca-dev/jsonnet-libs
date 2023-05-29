# Parca's jsonnet-libs

**Experimental** Jsonnet libraries for Parca

> **Warning**: APIs may change without notice.

## scrape-configs

Provides helper functions to generate scrape job configurations using
[Kubernetes service discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kubernetes_sd_config)
equivalent to [prometheus-operator](https://github.com/prometheus-operator/prometheus-operator)'s
[PodMonitor](https://prometheus-operator.dev/docs/operator/api/#monitoring.coreos.com/v1.PodMonitor) and
[ServiceMonitor](https://prometheus-operator.dev/docs/operator/api/#monitoring.coreos.com/v1.ServiceMonitor)
custom resources.

Install with [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler):

```shell
jb install github.com/parca-dev/jsonnet-libs/scrape-configs@main
```

See [examples](examples) for more details.
