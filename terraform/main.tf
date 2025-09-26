resource "helm_release" "my1app" {
  name      = "my1app-v2"
  namespace = var.namespace
  chart     = "../helm/myapp"
  wait      = false

  values = [
    file("${path.module}/../helm/myapp/values.yaml")
  ]

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  force_update = true

}
