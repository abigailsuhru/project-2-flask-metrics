provider "kubernetes" {}

provider "helm" {}

# Deploy the Helm chart for your app
resource "helm_release" "myapp" {
  name       = "myapp"
  namespace  = "default"
  chart      = "./helm/myapp"
  values     = [file("${path.module}/helm/myapp/values.yaml")]

  # Optional: Set any additional values here
  set {
    name  = "image.repository"
    value = "myapp-image-repo"
  }
  set {
    name  = "image.tag"
    value = "latest"
  }
}
