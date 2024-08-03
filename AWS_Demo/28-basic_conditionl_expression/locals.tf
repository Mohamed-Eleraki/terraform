locals {
  name  = (var.name != "" ? var.name : random_id.id.hex)
  owner = var.name

  common_tags = { # tags collection
    Owner = local.owner
    Name  = local.name
  }
}