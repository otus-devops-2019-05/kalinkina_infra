resource "google_compute_forwarding_rule" "default" {
  name = "http-lb"
  region = "${var.region}"
  target = "${google_compute_target_pool.default.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range  = "9292"
}

resource "google_compute_target_pool" "default" {
  name = "reddit-pool"
  region  = "${var.region}"
  session_affinity = "NONE"

  instances = [
    "europe-west1-b/reddit-app"
  ]

  health_checks = [
    "${google_compute_http_health_check.default.name}",
  ]
}

resource "google_compute_http_health_check" "default" {
  name = "check-reddit-app"
  request_path = "/"
  port  = "9292"
}
