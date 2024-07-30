resource "aws_key_pair" "bastion_host_key_pair_01" {
  key_name   = "bastion-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Deploy bastion host
resource "aws_instance" "bastion_host_01" {
  ami                         = "ami-0a3c3a20c09d6f377"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pub_subnet_01.id
  key_name                    = aws_key_pair.bastion_host_key_pair_01.key_name
  vpc_security_group_ids      = [aws_security_group.secgrp_bastion_02.id]
  user_data                   = <<-EOF
             #!/bin/bash
             sudo dnf install -y postgresql15 postgresql15-server
             sudo postgresql-setup --initdb
             sudo systemctl start postgresql
             sudo systemctl enable postgresql
             EOF

  tags = {
    Name = "bastion_host_01"
  }

}

output "ec2_public_IP" {
  value = aws_instance.bastion_host_01.public_ip
}