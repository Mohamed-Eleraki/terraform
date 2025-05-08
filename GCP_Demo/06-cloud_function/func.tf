resource "google_cloudfunctions2_function" "eraki_uscen1a_function_test_1002" {
  depends_on  = [google_storage_bucket_object.eraki_uscen1a_buc_obj_test_1001]
  name        = "${var.company_name}-${var.region_short}-function-${var.solution_name}"
  location    = var.region
  description = "Hello function"

  build_config {
    runtime     = "python311"
    entry_point = "hello_http"
    source {
      storage_source {
        bucket = google_storage_bucket.eraki_uscen1a_bucket_test_1001.name
        object = google_storage_bucket_object.eraki_uscen1a_buc_obj_test_1001.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
    ingress_settings   = "ALLOW_ALL"
  }
}

resource "google_cloudfunctions2_function_iam_member" "eraki_uscen1a_function_invoker_test_1001" {
  depends_on     = [google_cloudfunctions2_function.eraki_uscen1a_function_test_1002]
  project        = google_cloudfunctions2_function.eraki_uscen1a_function_test_1002.project
  location       = var.region
  cloud_function = google_cloudfunctions2_function.eraki_uscen1a_function_test_1002.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}
