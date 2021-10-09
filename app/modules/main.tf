resource "helm_release" "server" {
  name             = "server"
  chart            = "${path.module}/app"
  create_namespace = true
  namespace        = var.namespace

  values = [
    file("${path.module}/app/${var.environment}-values")
  ]

}