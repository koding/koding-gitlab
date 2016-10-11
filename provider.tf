provider "google" {
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
  credentials = "${file("${var.gcp_credential_path}")}"
}
