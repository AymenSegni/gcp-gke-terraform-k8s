# Summary: Creates a GKE (Google Kubernetes Engine) Autopilot cluster.

# Documentation: https://www.terraform.io/docs/language/settings/index.html
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}

# Documentation: https://www.terraform.io/docs/language/providers/requirements.html
provider "google" {
  project = var.project_id
  region  = var.region
}

# Documentation: configuring authentication to a GKE cluster using an OpenID Connect token retrieved from GCP as a kubeconfig file or as outputs intended for use with the kubernetes / helm providers.
# Source: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/auth
module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}

# kubeconfig file output
resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
}

# Documentation: Terraform VPC Network Module
# Source: https://github.com/terraform-google-modules/terraform-google-network
module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 3.4.0"
  project_id   = var.project_id
  network_name = "${var.network}-${var.env_name}"
  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
  ]
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}

# Document: Create a private Kubernetes Cluster
# Source: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/private-cluster
module "gke" {
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                      = var.project_id
  name                            = "${var.cluster_name}-${var.env_name}"
  regional                        = true
  region                          = var.region
  network                         = module.gcp-network.network_name
  subnetwork                      = module.gcp-network.subnets_names[0]
  ip_range_pods                   = var.ip_range_pods_name
  ip_range_services               = var.ip_range_services_name
  horizontal_pod_autoscaling      = var.enable_hpa
  enable_vertical_pod_autoscaling = var.enable_vpa
  node_pools = [
    {
      name           = "node-pool"
      machine_type   = var.machine_type
      node_locations = "europe-west1-b,europe-west1-c,europe-west1-d"
      min_count      = var.min_node_count
      max_count      = var.max_node_count
      disk_size_gb   = 30
    },
  ]
}
