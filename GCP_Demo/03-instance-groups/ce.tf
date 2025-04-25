# instance template
resource "google_compute_instance_template" "eraki_uscen1a_inst_temp_test_1001" {
  name_prefix  = "eraki-uscen1a-inst-temp-test-1001-"
  machine_type = "e2-medium"
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10 # Default value
  }
  network_interface {
    network = "default"
    access_config {
      # this for assign ephemeral IP Address
    }
  }
  service_account {
    email  = google_service_account.eraki_uscen1_srvacc_test_1001.email
    scopes = ["cloud-platform"]
  }
  metadata = {
    startup-script = <<EOF
            #!/bin/bash
            sudo apt update
            sudo apt install apache2 -y
            sudo echo 'Hello world from $(hostname) $(hostname -i)' | sudo tee /var/www/html/index.html
            # Create health check endpoint
            sudo mkdir -p /var/www/html/healthz
            sudo echo "Healthy" | sudo tee /var/www/html/healthz/index.html
            sudo service apache2 restart
        EOF
  }

  labels = {
    environment = "test"
  }

  tags = ["http-server"] # firewall tag definition

  lifecycle {
    create_before_destroy = true
  }
}

# service account
resource "google_service_account" "eraki_uscen1_srvacc_test_1001" {
  account_id   = "eraki-uscen1-srvacc-test-1001"
  display_name = "test 1001 machine service account"
}

# Construct IAM policy doc
data "google_iam_policy" "eraki_uscen1_srvacc_policydata_test_1001" {
  binding {
    role = "roles/iam.securityAdmin"
    members = [
      "serviceAccount:${google_service_account.eraki_uscen1_srvacc_test_1001.email}",
    ]
  }
}

# Apply IAM policy
resource "google_service_account_iam_policy" "eraki_uscen1_srvacc_policy_test_1001" {
  service_account_id = google_service_account.eraki_uscen1_srvacc_test_1001.name
  policy_data        = data.google_iam_policy.eraki_uscen1_srvacc_policydata_test_1001.policy_data
}

# health checkk resource
resource "google_compute_health_check" "eraki_uscen1_health_check_test_1001" {
  name                = "eraki-uscen1-health-check-test-1001"
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 secounds
  timeout_sec         = 5
  log_config {
    enable = false # or true to enable logging
  }

  http_health_check {
    request_path = "/healthz" # http get method protocol
    port         = "8080"     # specify the port freely
  }

  # If you specifically want a regional health check (which is sometimes required for 
  # certain regional services or to reduce latency), you should use 
  # the google_compute_region_health_check resource instead.
}

# Managed Instance group resouce
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager
resource "google_compute_region_instance_group_manager" "eraki_uscen1_managed_inst_group_test_1001" {
  name               = "eraki-uscen1-managed-inst-group-test-1001"
  region             = var.region
  base_instance_name = "eraki-uscen1-managed-inst-group-test-"
  version {
    instance_template = google_compute_instance_template.eraki_uscen1a_inst_temp_test_1001.id
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.eraki_uscen1_health_check_test_1001.id
    initial_delay_sec = 300
  }
}

# Autoscaler resource
resource "google_compute_region_autoscaler" "eraki_uscen1_auto_scaler_test_1001" {
  name   = "eraki-uscen1-auto-scaler-test-1001"
  region = var.region
  target = google_compute_region_instance_group_manager.eraki_uscen1_managed_inst_group_test_1001.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60 # Time (in seconds) to wait after scaling before collecting new metric

    cpu_utilization {
      target = 0.8 # 80%
    }
  }
}
