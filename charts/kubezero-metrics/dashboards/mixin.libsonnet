# https://github.com/kubernetes-monitoring/kubernetes-mixin

local kubernetes = import "kubernetes-mixin/mixin.libsonnet";

kubernetes {
  _config+:: {
    grafanaK8s+:: {
       dashboardNamePrefix: '',
      dashboardTags: ['kubernetes'],
    },
  },
}
