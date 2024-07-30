resource "aws_instance" "ec2_01" {
  ami                         = "ami-0a3c3a20c09d6f377"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet_01.id
  vpc_security_group_ids      = [aws_security_group.secgrp_01["ec2_01"].id]

  tags = merge({
    Name = local.instance_name
  },  local.common_tags)

}