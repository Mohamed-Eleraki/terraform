locals {
  name  = (var.name != "" ? var.name : random_id.id.hex)
  owner = var.name

  common_tags = {
    Name  = local.name
    Owner = local.owner
  }
}