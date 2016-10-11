resource "google_compute_disk" "mongo" {
  name  = "mongo-disk"
  zone  = "${var.cluster_zone}"
}
