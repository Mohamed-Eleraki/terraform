output "instance_external_ip" {
    value = google_compute_instance.eraki_ce_uscentral1a_test_1001.network_interface.0.access_config.0.nat_ip
    description = "The external IP address of the eraki_ce_uscentral1a_test_1001 instance."
}