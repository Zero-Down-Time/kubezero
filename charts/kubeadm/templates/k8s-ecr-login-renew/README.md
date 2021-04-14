# Create IAM role for ECR read-only access
- Attach managed policy: `AmazonEC2ContainerRegistryReadOnly`

# Create secret for IAM user for ecr-renew
`kubectl create secret -n kube-system generic ecr-renew-cred --from-literal=AWS_REGION=<AWS_REGION> --from-literal=AWS_ACCESS_KEY_ID=<AWS_SECRET_ID> --from-literal=AWS_SECRET_ACCESS_KEY=<AWS_SECRET_KEY>

# Resources
- https://github.com/nabsul/k8s-ecr-login-renew
