# Deploy the Helm chart for your app
resource "helm_release" "myapp" {
  name       = "myapp"
  namespace  = var.namespace
  chart      = "../helm/myapp"
  values     = [file("${path.module}/../helm/myapp/values.yaml")]

  # Optional: Set any additional values here
  set {
    name  = "image.repository"
    value = var.image_repository
  }
  set {
    name  = "image.tag"
    value = var.image_tag
  }
}
