variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  type        = string
}
variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "dev"
  type        = string
}
variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west1"
}
variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "gke-network"
}
variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-subnet"
  type        = string
}
variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
  type        = string
}
variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-services"
  type        = string
}

variable "enable_hpa" {
  description = "enable HPA"
  type        = bool
}

variable "enable_vpa" {
  description = "enable VPA"
  type        = bool
}

variable "machine_type" {
  description = "GKE machine type"
  default     = "e2-medium"
  type        = string
}

variable "min_node_count" {
  description = "gke min node count"
  type        = number
}

variable "max_node_count" {
  description = "gke max node count"
  type        = number
}
