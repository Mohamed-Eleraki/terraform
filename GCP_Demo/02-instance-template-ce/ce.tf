# instance template
resource "google_compute_instance_template" "eraki_inst_temp_uscentral1a_test_1001" {
    name_prefix = "eraki-inst-temp-uscen1-test-1001-"
    # machine_type = "n2-standard-2"
    machine_type = "e2-medium"
    region = "us-central1"

    disk {
        source_image = "debian-cloud/debian-11"
        auto_delete = true
        boot = true
        disk_size_gb = 10
    }

    network_interface {
        network = "default"
        access_config {}
    }

    service_account {
        email = google_service_account.eraki_srvacc_uscentral1a_test_1001.email
        scopes = ["cloud-platform"]
    }

    metadata = {
        startup-script = <<EOF
            #!/bin/bash
            sudo apt update
            sudo apt install apache2 -y \
            sudo echo 'Hello world from $(hostname) $(hostname -i)' | sudo tee /var/www/html/index.html \
            sudo service apache2 restart
        EOF
    }

    labels = {
        env = "dev"
    }
}

resource "google_service_account" "eraki_srvacc_uscentral1a_test_1001" {
    account_id   = "eraki-srvacc-uscen1a-test-1001"
    display_name = "test 1001 machine service account"
}

# resource "google_compute_instance" "eraki_ce_uscentral1a_test_1001" {
#     name = "eraki-ce-uscentral1a-test-1001"
#     zone = "us-central1-a"
#     machine_type = google_compute_instance_template.eraki_inst_temp_uscentral1a_test_1001.machine_type
#     template = google_compute_instance_template.eraki_inst_temp_uscentral1a_test_1001.id
#     labels = {
#         ce_env = "ce_dev"
#     }
# }

resource "google_compute_instance_from_template" "eraki_ce_uscentral1a_test_1001" {
    depends_on = [google_compute_firewall.eraki_allow_http_firewall_uscentral1a_test_1001]
    name = "eraki-ce-uscentral1a-test-1001"
    zone = "us-central1-a"
    source_instance_template = google_compute_instance_template.eraki_inst_temp_uscentral1a_test_1001.self_link_unique
    can_ip_forward = false
    labels = {
        instance_key = "instance_value"
    }
    tags = ["http-server"]
}

resource "google_compute_firewall" "eraki_allow_http_firewall_uscentral1a_test_1001" {
    name = "eraki-allow-http-fw-uscentral1a-test-1001"
    network = "default"
    allow {
        protocol = "tcp"
        ports = ["80"]
    }
    source_ranges = ["0.0.0.0/0"]
    # target_tags = [google_compute_instance_from_template.eraki_ce_uscentral1a_test_1001.name]  # not working
    target_tags = ["http-server"]
}