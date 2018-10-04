provider "google" {
 region = "${var.region}"
}

resource "random_id" "id" {
 keepers = {
  var.project_name = "${var.project_name}"
 }
 byte_length = 4
 prefix      = "${var.project_name}-"
}

resource "google_project" "project" {
  name            = "${var.project_name}"
  project_id      = "${random_id.id.dec}"
  billing_account = "${var.billing_account}"
}

resource "google_project_services" "project" {
 project = "${google_project.project.project_id}"
 services = [
   "compute.googleapis.com",
   "oslogin.googleapis.com",
   "storage-api.googleapis.com"
 ]
}

output "project_id" {
  value = "${google_project.project.id}"
}
