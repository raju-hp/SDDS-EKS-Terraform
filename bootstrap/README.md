# Bootstrap

Run this directory once from a trusted machine with AWS administrator credentials.

It creates:
- S3 bucket for Terraform state
- S3 versioning and encryption
- GitHub Actions OIDC provider
- GitHub Actions IAM role

IMPORTANT:
The first version attaches AdministratorAccess to the GitHub Actions role to simplify initial learning/testing. Replace it with a least-privilege policy before production.

Example:

terraform init
terraform apply   -var='state_bucket_name=sdds-terraform-state-UNIQUE-NAME'   -var='github_org=YOUR_GITHUB_ORG'   -var='github_repo=YOUR_GITHUB_REPO'

After applying, use the `state_bucket_name` output as the GitHub Actions
variable `TF_STATE_BUCKET`, and use the `github_actions_role_arn` output as
the GitHub Actions variable `AWS_ROLE_ARN`. Run this bootstrap before running
the root Terraform pipeline; the pipeline expects the bucket to already exist.
