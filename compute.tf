resource "google_compute_address" "default" {
  name = "${var.project_name}-ip"
  project = "${google_project_services.project.project}"
  region = "${var.region}"
}

resource "google_compute_instance" "default" {

 project = "${google_project_services.project.project}"
 zone = "${var.region}-a"
 allow_stopping_for_update = "true"
 name = "${var.project_name}-web"
 tags = ["web"]
 machine_type = "${var.machine_type}"

 boot_disk {
   initialize_params {
     size = "10"
     image = "centos-7"
     type = "pd-ssd"
   }
 }

 network_interface {
   network = "default"
   access_config {
     nat_ip = "${google_compute_address.default.address}"
   }
 }

 metadata {
   "ssh-keys" = "vagrant:${file("~/.ssh/id_rsa.pub")}"
 }

metadata_startup_script = "${file("startup.sh")}"

 service_account {
   scopes = ["userinfo-email", "compute-ro", "storage-full", "cloud-platform"]
 }

}

output "compute_instance_nat_ip" {
  value = "${google_compute_address.default.address}"
}
