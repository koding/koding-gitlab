resource "google_container_cluster" "kubernetes" {
    initial_node_count = "${var.cluster_size}"

    master_auth {
        username = "${var.cluster_kube_username}"
        password = "${var.cluster_kube_password}"
    }

    name = "${var.cluster_name}"
    zone = "${var.cluster_zone}"

    addons_config {
      http_load_balancing = {
        disabled = false
      }
      horizontal_pod_autoscaling = {
        disabled = false
      }
    }

    cluster_ipv4_cidr = "${var.cluster_cidr}"
    description = "Koding and Gitlab cluster on GCE"
    logging_service = "logging.googleapis.com"
    monitoring_service = "monitoring.googleapis.com"
    network = "${google_compute_network.kubernetes.name}"

    node_config {
        machine_type = "${var.cluster_machine_type}"
        disk_size_gb = "${var.cluster_disk_size_gb}"
        oauth_scopes = [
            "https://www.googleapis.com/auth/compute",                 # compute-rw
            "https://www.googleapis.com/auth/monitoring",              # monitoring
            "https://www.googleapis.com/auth/monitoring.write",        # monitoring-write
            "https://www.googleapis.com/auth/logging.write",           # logging-write
            "https://www.googleapis.com/auth/devstorage.read_write",   # storage-rw
            "https://www.googleapis.com/auth/taskqueue",               # taskqueue
            "https://www.googleapis.com/auth/datastore",               # datastore
        ]
    }

    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
}

output "kube_endpoint" {
    value = "${google_container_cluster.kubernetes.endpoint}"
}

output "kube_instance_group_urls" {
    value = "${google_container_cluster.kubernetes.instance_group_urls.0}"
}

output "kube_client_certificate" {
    value = "${google_container_cluster.kubernetes.master_auth.0.client_certificate}"
}

output "kube_client_key" {
    value = "${google_container_cluster.kubernetes.master_auth.0.client_key}"
}

output "kube_cluster_ca_certificate" {
    value = "${google_container_cluster.kubernetes.master_auth.0.cluster_ca_certificate}"
}
