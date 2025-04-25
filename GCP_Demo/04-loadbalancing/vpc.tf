# VPC resource
resource "google_compute_network" "eraki_uscen1_vpc01_test_1001" {
  # name                    = "eraki-uscen1-vpc01-test-1001"
  name                    = "${var.company_name}-${var.region_short}-vpc01-${var.solution_name}"
  auto_create_subnetworks = false
}

# subnet resouce
resource "google_compute_subnetwork" "eraki_uscen1_subnet01_test_1001" {
  # name          = "eraki-uscen1-subnet01-test-1001"
  name          = "${var.company_name}-${var.region_short}-subnet01-${var.solution_name}"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.eraki_uscen1_vpc01_test_1001.id
}

# Firewall resource
resource "google_compute_firewall" "eraki_uscen1_firewall_test_1001" {
  # name    = "eraki-uscen1-firewall-test-1001"
  name    = "${var.company_name}-${var.region_short}-firewall-${var.solution_name}"
  network = google_compute_network.eraki_uscen1_vpc01_test_1001.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"] # to be mentioned on the instance template tags
}