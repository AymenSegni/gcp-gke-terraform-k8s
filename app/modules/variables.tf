# variable "namespace" {
#   description = "app namespace"
#   type        = string
# }

variable "environment" {
  description = "environment name"
  type        = string
}

variable "postgresqlPassword" {
  description = "postgresql Password"
  type        = string
}

variable "postgresqlUsername" {
  description = "postgresql Username"
  type        = string
}

variable "postgresqlDatabase" {
  description = "postgresql Database"
  type        = string
}