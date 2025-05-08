resource "google_storage_bucket" "eraki_uscen1a_bucket_test_1001" {
  name          = "${var.company_name}-${var.region_short}-bucket-${var.solution_name}"
  location      = var.region
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_object" "eraki_uscen1a_buc_obj_test_1001" {
  name = "${var.company_name}-${var.region_short}-buc_obj-${var.solution_name}"
  #   source = "/sources/function-source.zip"
  source = "${path.module}/sources/function-source.zip"
  bucket = google_storage_bucket.eraki_uscen1a_bucket_test_1001.name
}

resource "google_storage_bucket" "eraki_uscen1a_bucket_dummy_1001" {
  name          = "${var.company_name}-${var.region_short}-bucket_dummy-${var.solution_name}"
  location      = var.region
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}
