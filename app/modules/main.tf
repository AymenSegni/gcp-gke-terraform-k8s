resource "helm_release" "server" {
  name             = "server"
  chart            = "${path.module}/app"
  # create_namespace = true
  # namespace        = var.namespace

  set_sensitive {
    name  = "secrets.postgresql.user"
    value = var.postgresqlUsername
  }

  set_sensitive {
    name  = "secrets.postgresql.database"
    value = var.postgresqlDatabase
  }

  set_sensitive {
    name  = "secrets.postgresql.password"
    value = var.postgresqlPassword
  }

  values = [
    file("${path.module}/app/${var.environment}-values.yaml")
  ]

}