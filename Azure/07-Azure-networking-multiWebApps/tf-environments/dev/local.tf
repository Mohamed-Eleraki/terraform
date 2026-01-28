locals {
  all_tags = merge(
    {
      Region         = var.region
      Automation     = "True"
      ServiceAccount = "Terraform-pipeline"
      CostCenter     = "West Europe"
    },
    {
      Application    = "NONE"
      Environment    = "NONE"
      BackupSchedule = "NONE"
      BackupType     = "NONE"
    }
  )

  # VM TAGS
  vm_tags = {
    core = {
      Name        = "core-${var.region}-vm"
      Environment = "dev"
      Application = "core"
    }
    app = {
      Name        = "app-${var.region}-vm"
      Environment = "dev"
      Application = "app"
    }
  }
}