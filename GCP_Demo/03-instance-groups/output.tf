output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.eraki_uscen1_lb_forwarding_rule.ip_address
}