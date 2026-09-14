# SDDS EKS Deployment Checklist

## Phase 0 - Prerequisites

- AWS account
- IAM administrator access for one-time bootstrap
- GitHub repository
- Git installed
- AWS CLI
- Terraform >= 1.10
- kubectl
- Docker Desktop/Engine (only needed for local image testing)

## Phase 1 - Bootstrap

1. Set the AWS CLI profile/credentials locally.
2. Enter `bootstrap/`.
3. Run:
   ```
   terraform init
   terraform apply -var='state_bucket_name=UNIQUE-BUCKET-NAME' -var='github_org=ORG' -var='github_repo=REPO'
   ```
4. Record the state bucket and role ARN.

## Phase 2 - Configure Terraform

1. Put the state bucket name into `versions.tf`.
2. Put the GitHub Actions role ARN into `env/dev.tfvars`.
3. Run:
   ```
   terraform init -migrate-state
   terraform fmt -recursive
   terraform validate
   ```

## Phase 3 - GitHub

Repository variables:
- AWS_ROLE_ARN
- AWS_ACCOUNT_ID

Environment `dev` secret:
- SDDS_PASSWORD

The workflow needs:
- `id-token: write`
- `contents: read`

Do not create long-lived AWS access key secrets.

## Phase 4 - AWS connectivity

Run `AWS Connectivity Test`.

Expected command output:
`aws sts get-caller-identity`

The ARN should be the GitHub Actions role.

## Phase 5 - Terraform

Pull request:
- Terraform Plan

Merge to `main`:
- Terraform Apply

Expected resources:
- VPC
- 2 public subnets
- 2 private subnets
- Internet Gateway
- NAT Gateway
- EKS
- 2 EKS managed nodes
- ECR
- EFS
- Secrets Manager
- CloudWatch/EKS observability
- EKS Pod Identity

## Phase 6 - Kubernetes

After apply:

```
aws eks update-kubeconfig --region us-east-1 --name dev-sdds-eks
kubectl get nodes
```

Both nodes should be `Ready`.

## Phase 7 - EFS

The deployment workflow reads the EFS IDs from Terraform state and renders `k8s/efs-pv.yaml`.

## Phase 8 - Application

Replace the sample `Dockerfile` with the real SDDS application build.

Ensure the application:
- listens on the configured port
- writes logs to `/var/log/sdds`
- uses the AWS SDK to retrieve `sdds/dev/application` from Secrets Manager
- uses the `sdds-app` Kubernetes service account

## Phase 9 - Validation

```
kubectl -n sdds get all
kubectl -n sdds get pvc
kubectl -n sdds describe pod <pod>
kubectl -n sdds logs <pod>
aws ecr describe-images --repository-name sdds/sdds
```

## Phase 10 - Cleanup

For a learning environment:

```
terraform destroy -var-file="env/dev.tfvars"
```

Before destroying:
- back up anything important
- understand EFS retention
- remove application data if appropriate
- keep Terraform state until cleanup is confirmed
