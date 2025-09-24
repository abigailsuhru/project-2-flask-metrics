variable "namespace" {
  description = "The Kubernetes namespace to deploy the app"
  type        = string
  default     = "default"
}

variable "image_repository" {
  description = "The Docker image repository for the app"
  type        = string
}

variable "image_tag" {
  description = "The Docker image tag for the app"
  type        = string
  default     = "latest"
}
