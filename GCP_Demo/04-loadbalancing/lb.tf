# Backend service with health check
resource "google_compute_backend_service" "eraki_uscen1a_lb_backend_test_1001" {
  # name        = "eraki-uscen1a-lb-backend-test-1001"
  name        = "${var.company_name}-${var.region_short}-lb-backend-${var.solution_name}"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
  enable_cdn  = false

  backend {
    group = google_compute_region_instance_group_manager.eraki_uscen1_managed_inst_group_test_1001.instance_group
  }

  health_checks = [google_compute_health_check.eraki_uscen1_health_check_test_1001.id]
}

# url map (routing rules)
resource "google_compute_url_map" "eraki_uscen1_url_map_test_1001" {
  # name            = "eraki-uscen1-url-map-test-1001"
  name            = "${var.company_name}-${var.region_short}-url-map-${var.solution_name}"
  default_service = google_compute_backend_service.eraki_uscen1a_lb_backend_test_1001.id

  host_rule {
    hosts        = ["*"] # match all
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.eraki_uscen1a_lb_backend_test_1001.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.eraki_uscen1a_lb_backend_test_1001.id
    }
  }
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "eraki_uscen1_http_proxy_test_1001" {
  # name    = "eraki-uscen1-http-proxy-test-1001"
  name    = "${var.company_name}-${var.region_short}-http-proxy-${var.solution_name}"
  url_map = google_compute_url_map.eraki_uscen1_url_map_test_1001.id
}

# Global forwarding rule (public ip)
resource "google_compute_global_forwarding_rule" "eraki_uscen1_glob_forwarding_rule_test_1001" {
  # name        = "eraki-uscen1-glob-forwarding-rule-test-1001"
  name        = "${var.company_name}-${var.region_short}-glob-forwarding-rule-${var.solution_name}"
  target      = google_compute_target_http_proxy.eraki_uscen1_http_proxy_test_1001.id
  port_range  = "80"
  ip_protocol = "TCP"
}

# Firewall rule to allow lb health check
resource "google_compute_firewall" "eraki_uscen1_fw_allow_lb_healthcheck_test_1001" {
  # name    = "eraki-uscen1-fw-allow-lb-healthcheck-test-1001"
  name    = "${var.company_name}-${var.region_short}-fw-allow-lb-healthcheck-${var.solution_name}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"] # Match the health ckeck port
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"] # GCP health check ranges
  target_tags   = ["http-server"]
}

