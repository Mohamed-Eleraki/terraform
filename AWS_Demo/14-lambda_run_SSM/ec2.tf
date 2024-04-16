# Create security group for ec2 instance
resource "aws_security_group" "security_group_1_ec2" {
  name   = "security_Group_1_ec2"
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    name = "security_Group_1_ec2"
  }
}

# Create ingress role for security group - specify your ports to allow as below
resource "aws_vpc_security_group_ingress_rule" "allow_SSH_inbound_traffic" {
  security_group_id = aws_security_group.security_group_1_ec2.id
  #cidr_ipv4         = aws_vpc.vpc_1.cidr_block
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

# create egress role - allow all
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_ipv4" {
  security_group_id = aws_security_group.security_group_1_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create Key pair for ec2 instnace
resource "aws_key_pair" "kp-1" {
  key_name   = "server_key"
  public_key = file("~/.ssh/id_rsa.pub") # based on you public key
}

# Create instance profile holds the SSM IAM role in order to attach it to ec2
resource "aws_iam_instance_profile" "iam_profile" {
  name = "iam_profile"
  role = aws_iam_role.ssm_role.name
}

# Create an EC2 Instance
resource "aws_instance" "ec2_instance_1" {
  ami                         = "ami-0a3c3a20c09d6f377"
  instance_type               = "t2.micro"
  associate_public_ip_address = true # avoid to submit this on production , at least use security group to accecpt traffic
  subnet_id                   = aws_subnet.subnet_1.id
  security_groups             = [aws_security_group.security_group_1_ec2.id]
  key_name                    = aws_key_pair.kp-1.key_name
  iam_instance_profile        = aws_iam_instance_profile.iam_profile.name

  tags = {
    name = "ec2_instance_1"
  }

  #   provisioner "local-exec" {
  #     command = "sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm && sudo systemctl start amazon-ssm-agent"
  #   }

  # Install the SSM Agent
  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              sudo systemctl start amazon-ssm-agent
              EOF
}