provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "cloudflare_record" "www" {
  domain  = "${var.cloudflare_zone}"
  name    = "www"
  value   = "${google_compute_address.default.address}"
  type    = "A"
  ttl     = 1
  proxied = true
}
