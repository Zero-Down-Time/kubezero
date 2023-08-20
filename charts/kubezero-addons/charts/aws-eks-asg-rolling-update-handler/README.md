# aws-eks-asg-rolling-update-handler

## Configuration
The following table lists the configurable parameters of the aws-eks-asg-rolling-update-handler chart and their default values.
| Parameters | Description | Required | Default     |
|:-----------|:------------|:---------|:------------|
| environmentVars  | environment variables for aws-eks-asg-rolling-update-handler container, available variables are listed [here](https://github.com/TwiN/aws-eks-asg-rolling-update-handler/blob/master/README.md#usage) | yes |`[{"name":"CLUSTER_NAME","value":"cluster-name"}]`|
| replicaCount | Number of aws-eks-asg-rolling-update-handler replicas | yes |`1` |
| image.repository | Image repository | yes |  `twinproduction/aws-eks-asg-rolling-update-handler` |
| image.tag | image tag | yes | `v1.4.3` |
| image.pullPolicy | Image pull policy | yes | `IfNotPresent` |
| resources | CPU/memory resource requests/limits | no | `{}` |
| podAnnotations | Annotations to add to the aws-eks-asg-rolling-update-handler pod configuration | no | `{}` |
| podLabels | Labels to add to the aws-eks-asg-rolling-update-handler pod configuration | no | `{}` |
