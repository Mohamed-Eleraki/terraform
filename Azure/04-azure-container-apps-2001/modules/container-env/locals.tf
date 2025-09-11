locals {
  all_tags = merge(
    {
      Region         = var.region
      Automation     = "True"
      ServiceAccount = "Terrafrom-pipeline"
      CostCenter     = "East US"
    },
    {
      Application    = "NONE"
      BackupSchedule = "NONE"
      BackupType     = "NONE"
    }
  )
}
