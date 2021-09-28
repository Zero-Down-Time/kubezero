# https://github.com/kubernetes-monitoring/kubernetes-mixin

local kubernetes = import "kubernetes-mixin/mixin.libsonnet";

kubernetes {
  _config+:: {
    kubeApiserverSelector: 'job="apiserver"',
    grafanaK8s+:: {
      linkPrefix: '',
      dashboardNamePrefix: '',
      dashboardTags: ['kubernetes'],
    },
  },
}
