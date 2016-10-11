// provider
variable "gcp_project" {
  default = "kodingdev-vms"
}

variable "gcp_region" {
    default = "us-central1"
}

variable "gcp_credential_path" {
    default = "account.json"
}

// main
variable "cluster_name" {
    default = "koding-gitlab"
}

variable "cluster_zone" {
    default = "us-central1-a"
}

variable "cluster_size" {
    default = 3
}

variable "cluster_cidr" {
    default = "10.1.0.0/16"
}

variable "network_cidr" {
    default = "10.128.0.0/20"
}

variable "cluster_machine_type" {
    default = "n1-standard-2"
}

variable "cluster_disk_size_gb" {
    default = "100"
}

variable "cluster_kube_username" {
    default = "admin"
}

variable "cluster_kube_password" {
    default = "minda"
}

variable "current_ip" {
    default = "127.0.0.1/32"
}
