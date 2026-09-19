# Bootstrap

Run this directory once from a trusted machine with AWS administrator credentials.

It creates:
- GitHub Actions OIDC provider
- GitHub Actions IAM role

Create the S3 state bucket manually before running the root pipeline:
`sdds-terraform-state-dev`. Enable versioning, default server-side encryption,
and block all public access.

IMPORTANT:
The first version attaches AdministratorAccess to the GitHub Actions role to simplify initial learning/testing. Replace it with a least-privilege policy before production.

Example:

terraform init
terraform apply   -var='github_org=YOUR_GITHUB_ORG'   -var='github_repo=YOUR_GITHUB_REPO'

After applying, use the `github_actions_role_arn` output as the GitHub Actions
variable `AWS_ROLE_ARN`. The root pipeline uses the manually created bucket.
