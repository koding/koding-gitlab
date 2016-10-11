resource "google_compute_disk" "mongo" {
  name  = "${var.cluster_name}-mongo-disk"
  zone  = "${var.cluster_zone}"
}
