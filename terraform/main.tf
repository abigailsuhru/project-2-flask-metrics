resource "helm_release" "my1app" {
  name      = "my1app"
  namespace = var.namespace
  chart     = "../helm/my1app"
  values    = [file("${path.module}/../helm/my1app/values.yaml")]

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }
}
