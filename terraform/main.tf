provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "my_ns" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "myapp" {
  name       = "myapp"
  namespace  = kubernetes_namespace.my_ns.metadata[0].name
  chart      = "../helm/myapp"
  values     = [file("${path.module}/../helm/myapp/values.yaml")]

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  depends_on = [kubernetes_namespace.my_ns]
}
