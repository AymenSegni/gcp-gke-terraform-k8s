variable "enable_ha" {
  description = "Enable HA on Prod"
  type        = bool

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