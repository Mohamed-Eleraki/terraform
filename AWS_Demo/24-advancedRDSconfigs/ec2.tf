# Deploy key pair
resource "aws_key_pair" "bastion_host_key_pair_01" {
  key_name = "bastion-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# Deploy bastion host
resource "aws_instance" "bastion_host_01" {
  ami = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.pub_subnet_01
  key_name = aws_key_pair.bastion_host_key_pair_01.key_name
  vpc_security_group_ids = [aws_security_group.secgrp_bastion_02.id]

  tags = {
    Name = "bastion_host_01"
  }

}