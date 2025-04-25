# VPC resource
resource "google_compute_network" "eraki_uscen1_vpc01_test_1001" {
  name                    = "eraki-uscen1-vpc01-test-1001"
  auto_create_subnetworks = false
}

# subnet resouce
resource "google_compute_subnetwork" "eraki_uscen1_subnet01_test_1001" {
  name          = "eraki-uscen1-subnet01-test-1001"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.eraki_uscen1_vpc01_test_1001.id
}

# Firewall resource
resource "google_compute_firewall" "eraki_uscen1_firewall_test_1001" {
  name    = "eraki-uscen1-firewall-test-1001"
  network = google_compute_network.eraki_uscen1_vpc01_test_1001.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"] # to be mentioned on the instance template tags
}