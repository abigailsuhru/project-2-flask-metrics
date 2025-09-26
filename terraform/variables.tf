variable "image_repository" {
  description = "Full ECR repository URL"
  type        = string
  default     = "507363615947.dkr.ecr.eu-central-1.amazonaws.com/myapp-image"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}
