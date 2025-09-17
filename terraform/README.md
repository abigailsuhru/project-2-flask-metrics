# Terraform

export TF_VAR_github_owner="YOUR_GITHUB_OWNER"
export TF_VAR_github_repo="YOUR_REPO_NAME"
# Optionally choose a region
# export TF_VAR_region="eu-central-1"

terraform init
terraform apply -auto-approve

# After apply, note outputs: cluster_name, ecr_repo_url, gha_role_arn
# Update GitHub Actions secrets accordingly.
