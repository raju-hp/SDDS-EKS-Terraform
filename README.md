# SDDS on AWS EKS - Terraform + GitHub Actions

This project creates a small production-style learning environment for an SDDS application:

- VPC with 2 public + 2 private subnets
- Internet Gateway
- One NAT Gateway
- Amazon EKS
- 2 managed worker nodes by default
- Amazon ECR
- Amazon EFS with access point
- AWS Secrets Manager
- CloudWatch/EKS logging
- EKS Pod Identity
- GitHub Actions with AWS OIDC
- S3 remote Terraform state with S3 lockfile

## Important

This repository is an educational baseline. Before production, review:
- EKS public endpoint CIDRs
- IAM least privilege
- secret handling/state exposure
- NAT Gateway high availability
- ECR image scanning
- container security
- Kubernetes network policies
- ingress/load-balancer design
- backup/DR
- CloudWatch alarms
- encryption keys and key policies

## 1. Bootstrap

The bootstrap must be run once from a trusted machine with AWS administrator credentials.

```bash
cd bootstrap
terraform init
terraform apply   -var='state_bucket_name=sdds-terraform-state-UNIQUE-NAME'   -var='github_org=YOUR_GITHUB_ORG'   -var='github_repo=YOUR_GITHUB_REPO'
```

Record:
- state bucket name
- GitHub Actions role ARN

The bootstrap intentionally attaches AdministratorAccess to the GitHub Actions role to simplify the first implementation. Replace this with least privilege before production.

## 2. Configure backend

Add a GitHub repository or environment variable named `TF_STATE_BUCKET` with
the state bucket name created by bootstrap. The pipeline passes this value to
`terraform init` and stores state under an environment-specific key:

`sdds/<environment>/terraform.tfstate`

Then from the repository root, initialize the backend locally with the bucket
name supplied explicitly:

```bash
terraform init \
	-backend-config='bucket=YOUR_STATE_BUCKET' \
	-backend-config='key=sdds/dev/terraform.tfstate'
```

If you had previously initialized a local backend, use:

```bash
terraform init -migrate-state
```

Do not commit `terraform.tfstate`.

## 3. Test locally

Set the secret only in your shell:

PowerShell:

```powershell
$env:TF_VAR_sdds_password = "ChangeMe"
```

Linux/macOS:

```bash
export TF_VAR_sdds_password='ChangeMe'
```

Then:

```bash
terraform fmt -recursive
terraform validate
terraform plan -var-file="env/dev.tfvars"
terraform apply -var-file="env/dev.tfvars"
```

## 4. GitHub variables

Repository Settings -> Secrets and variables -> Actions.

Variables:
- `AWS_ROLE_ARN`
- `AWS_ACCOUNT_ID`

Environment `dev`:
- Secret: `SDDS_PASSWORD`

No long-lived AWS access key is required.

## 5. GitHub Actions order

1. `AWS Connectivity Test`
2. `Terraform Plan` on pull requests
3. `Terraform Apply` after merge to main
4. `SDDS Application Deploy` when app/Kubernetes files change

## 6. EKS access

After apply:

```bash
aws eks update-kubeconfig --region us-east-1 --name dev-sdds-eks
kubectl get nodes
```

## 7. EFS manifest

Get Terraform outputs:

```bash
terraform output efs_file_system_id
terraform output efs_access_point_id
```

Render the PV:

```bash
EFS_ID=$(terraform output -raw efs_file_system_id)
ACCESS_POINT_ID=$(terraform output -raw efs_access_point_id)

sed   -e "s/REPLACE_WITH_EFS_FILE_SYSTEM_ID/${EFS_ID}/"   -e "s/REPLACE_WITH_EFS_ACCESS_POINT_ID/${ACCESS_POINT_ID}/"   k8s/efs-pv.yaml > /tmp/efs-pv.yaml
```

The example application workflow should be adjusted to perform the same rendering automatically.

## 8. Terraform command correction

Use:

```bash
terraform plan -var-file="env/dev.tfvars"
```

not:

```bash
terraform plan --var="env/dev.tfvars"
```

`-var` is for `name=value`; `-var-file` loads a tfvars file.

## Official documentation used

- AWS EKS Kubernetes versions: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
- AWS EFS CSI driver for EKS: https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html
- AWS EKS add-ons: https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html
- AWS EKS Pod Identity: https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html
- GitHub OIDC with AWS: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
- Terraform S3 backend: https://developer.hashicorp.com/terraform/language/backend/s3
