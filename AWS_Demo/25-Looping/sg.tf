resource "aws_security_group" "secgrp_01" {
  for_each = var.secgrps
  name        = "${local.region}-${local.name}-${local.environment}-${each.key}"
  description = coalesce(each.value.description, "${local.name}-${each.key}")
  vpc_id = aws_vpc.vpc_01.id
  tags = merge({
    Name = "${local.region}-${each.key}"
    service = "security groups"
  }, local.common_tags)


  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port = ingress.value["from_port"]
      to_port =  ingress.value["to_port"]
      protocol = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
      security_groups =  ingress.value["security_groups"]
      description = ingress.value["description"]
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      from_port = egress.value["from_port"]
      to_port = egress.value["to_port"]
      protocol = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
      security_groups = egress.value["security_groups"]
      description = egress.value["description"]
    }
  }
}