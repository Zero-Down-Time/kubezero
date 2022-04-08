local addMixin = (import 'kube-prometheus/lib/mixin.libsonnet');

local etcdMixin = addMixin({
  name: 'etcd',
  mixin: (import 'github.com/etcd-io/etcd/contrib/mixin/mixin.libsonnet') +
         {
           _config+: {
             etcd_instance_labels: 'instance, pod',
           },
         } +
         // Remove both etcdHighNumberOfFailedGRPCRequests from etcd-mixin for now
         {
           prometheusAlerts+: {
             groups: std.map(
               function(group)
                 if group.name == 'etcd' then
                   group {
                     rules: std.filter(
                       function(rule)
                         rule.alert != 'etcdHighNumberOfFailedGRPCRequests',
                       group.rules
                     ),
                   }
                 else
                   group,
               super.groups
             ),
           },
         },
});

local kp = (import 'kube-prometheus/main.libsonnet') +
           {
             values+:: {
               common+: {
                 namespace: 'monitoring',
               },
             },
           };

// We just want the Prometheus Rules
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ 'alertmanager-prometheusRule': kp.alertmanager.prometheusRule } +
{ 'kube-state-metrics-prometheusRule': kp.kubeStateMetrics.prometheusRule } +
{ 'kubernetes-prometheusRule': kp.kubernetesControlPlane.prometheusRule } +
{ 'node-exporter-prometheusRule': kp.nodeExporter.prometheusRule } +
{ 'prometheus-prometheusRule': kp.prometheus.prometheusRule } +
{ 'etcd-mixin-prometheusRule': etcdMixin.prometheusRules }
