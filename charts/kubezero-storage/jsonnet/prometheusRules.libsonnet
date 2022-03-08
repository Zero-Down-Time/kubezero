local addMixin = (import 'kube-prometheus/lib/mixin.libsonnet');

local openebsMixin = addMixin({
  name: 'openebs',
  mixin: (import 'github.com/openebs/monitoring/jsonnet/openebs-mixin/mixin.libsonnet') +
         (import 'config.libsonnet'),
});

{ 'openebs-mixin-prometheusRules': openebsMixin.prometheusRules }
