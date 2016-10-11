resource "google_compute_network" "kubernetes" {
  name                    = "${var.cluster_name}"
  description             = "Network for Koding And Gitlab on Kubernetes"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "kubernetes" {
  name          = "${var.cluster_name}-kubernetes"
  ip_cidr_range = "${var.network_cidr}"
  network       = "${google_compute_network.kubernetes.self_link}"
  region        = "${var.gcp_region}"
}

resource "google_compute_firewall" "kubernetes-allow-icmp" {
  name    = "${var.cluster_name}-kubernetes-allow-icmp"
  network = "${google_compute_network.kubernetes.name}"
  description = "Allow icmp requests from internet"

  allow {
    protocol = "icmp"
  }

  source_ranges = [ "0.0.0.0/0" ]
}


resource "google_compute_firewall" "kubernetes-allow-internal" {
  name    = "${var.cluster_name}-kubernetes-allow-internal"
  network = "${google_compute_network.kubernetes.name}"
  description = "Allow all communication within cluster"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = [ "0-65535" ]
  }

  allow {
    protocol = "udp"
    ports    = [ "0-65535" ]
  }

  source_ranges = [ "${var.network_cidr}" ]
}

// kubernetes-allow-rdp
resource "google_compute_firewall" "kubernetes-allow-rdp" {
  name    = "${var.cluster_name}-kubernetes-allow-rdp"
  network = "${google_compute_network.kubernetes.name}"
  description = "Allow all communication within cluster"

  allow {
    protocol = "tcp"
    ports    = [ "3389" ]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

// kubernetes-allow-ssh
resource "google_compute_firewall" "kubernetes-allow-ssh" {
  name    = "${var.cluster_name}-kubernetes-allow-ssh"
  network = "${google_compute_network.kubernetes.name}"
  description = "Allow all communication within cluster"

  allow {
    protocol = "tcp"
    ports    = [ "22" ]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

// kubernetes-allow-healthz
resource "google_compute_firewall" "kubernetes-allow-healthz" {
  name    = "${var.cluster_name}-kubernetes-allow-healthz"
  network = "${google_compute_network.kubernetes.name}"
  description = "Allow all communication within cluster"

  allow {
    protocol = "tcp"
    ports    = [ "8080" ]
  }

  source_ranges = [ "130.211.0.0/22" ] # gcp ips
}


// kubernetes-allow-api-server
resource "google_compute_firewall" "kubernetes-allow-api-server" {
  name    = "${var.cluster_name}-kubernetes-allow-api-server"
  network = "${google_compute_network.kubernetes.name}"
  description = "Allow all communication within cluster"

  allow {
    protocol = "tcp"
    ports    = [ "6443" ]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

// kubernetes-koding-endpoint
resource "google_compute_firewall" "kubernetes-allow-api-koding-endpoint" {
  name    = "${var.cluster_name}-kubernetes-allow-koding-endpoint"
  network = "${google_compute_network.kubernetes.name}"
  description = "Allow all communication within cluster"

  allow {
    protocol = "tcp"
    ports    = [ "8090" ]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

// kubernetes-allow-from-current
resource "google_compute_firewall" "kubernetes-allow-from-current" {
  name    = "${var.cluster_name}-kubernetes-allow-from-current"
  network = "${google_compute_network.kubernetes.name}"
  description = "Allow all communication within cluster"

  allow {
    protocol = "tcp"
    ports    = [ "0-65535" ]
  }

  source_ranges = [  "${var.current_ip}" ]
}
