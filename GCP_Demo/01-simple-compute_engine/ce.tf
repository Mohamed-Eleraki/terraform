resource "google_compute_instance" "eraki_ce_uscentral1a_test_1001" {
  name                      = "eraki-ce-uscentral1a-test-1001"
  zone                      = "us-central1-a"
  machine_type              = "n2-standard-2"
  allow_stopping_for_update = true # Note: If you want to update this value (resize the VM) after initial creation, you must set allow_stopping_for_update to true.
  deletion_protection       = false

  network_interface {
    network = "default"
    access_config {
      // leave it empty to assign an ephemeral public IP
      nat_ip = google_compute_address.eraki_static_ip_uscentral1a_test_1001.address
    }
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      # size = 50  # By default 10 G
      labels = {
        disk_type = "boot_disk"
      }
    }
  }

  service_account {
    email  = google_service_account.eraki_srvacc_uscentral1a_test_1001.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install apache2 -y \
    sudo echo 'Hello world from $(hostname) $(hostname -i)' | sudo tee /var/www/html/index.html \
    sudo service apache2 restart 
    EOF

  labels = {
    lab_env = "lab_dev"
  }

}

resource "google_service_account" "eraki_srvacc_uscentral1a_test_1001" {
  account_id   = "eraki-srvacc-uscen1a-test-1001"
  display_name = "test 1001 machine service account"
}

resource "google_compute_resource_policy" "eraki_daily_backup_uscentral1a_test_1001" {
  name   = "eraki-daily-backup-uscentral1a-test-1001"
  region = "us-central1"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }

    retention_policy {
      max_retention_days    = 10
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }

    snapshot_properties {
      labels = {
        my_label = "value"
      }
      storage_locations = ["us"]
      guest_flush       = true
    }
  }
}

resource "google_compute_firewall" "eraki_allow_http_firewall_uscentral1a_test_1001" {
  name    = "eraki-allow-http-fw-uscentral1a-test-1001"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [google_compute_instance.eraki_ce_uscentral1a_test_1001.name]
}

resource "google_compute_address" "eraki_static_ip_uscentral1a_test_1001" {
    name = "eraki-static-ip-uscentral1a-test-1001"
    region = "us-central1"
}