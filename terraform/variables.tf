variable "region" {
  type    = string
  default = "eu-west-1" # Ireland (close to NL)
}

variable "project_name" {
  type    = string
  default = "devops-project-2"
}

variable "github_owner" { type = string }
variable "github_repo"  { type = string }
