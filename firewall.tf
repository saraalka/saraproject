data "google_compute_network" "default" {
  project = "${google_project_services.project.project}"
  name = "default"
}

resource "google_compute_firewall" "allow_icmp" {
    name = "allow-icmp"
    project = "${google_project_services.project.project}"
    network = "default"

    allow {
        protocol = "icmp"
    }

    source_ranges = ["0.0.0.0/0"]
}

data "cloudflare_ip_ranges" "cloudflare" {}

resource "google_compute_firewall" "allow_cloudflare" {
    name = "allow-cloudflare"
    project = "${google_project_services.project.project}"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80"]
    }
    allow {
        protocol = "tcp"
        ports = ["443"]
    }

    source_ranges = ["${data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks}"]
    target_tags = ["web"]
}
