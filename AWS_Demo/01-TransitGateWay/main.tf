# Configure aws provider
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configure aws provider
provider "aws" {
    region = "us-east-1"
}

# Variable
variable "dev_vpc1_cidr_block" {
    description = "Development step cidr_block"
}

variable "dev_vpc2_cidr_block" {
    description = "Development step cidr_block"
}
variable "dev_vpc3_cidr_block" {
    description = "Development step cidr_block"
}
variable "environment" {
    description = "Development step Name"
}

variable "dev_subnet1_cidr_block" {
    description = "Development subnet1 cidr_block"  
}

variable "dev_subnet2_cidr_block" {
    description = "Development subnet2 cidr_block"  
}

variable "dev_subnet3_cidr_block" {
    description = "Development subnet3 cidr_block"  
}


# Create a VPC-1 | VPC-1 Configurations
resource "aws_vpc" "vpc-1" {
    cidr_block = var.dev_vpc1_cidr_block
    tags = {
        Name = "${var.environment}-vpc-1"
    }
}

# Create Internet gateway1
resource "aws_internet_gateway" "igw-1" {
    vpc_id = aws_vpc.vpc-1.id
    tags = {
      Name = "${var.environment}-IGW-1"
    }
}

# Create subnet-1 for VPC-1
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = var.dev_subnet1_cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.environment}-subnet-1"
  }
}

# Create a route table
resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"  # Represents all IP addresses (i.e., internet-bound traffic)
    gateway_id = aws_internet_gateway.igw-1.id
  }

  route {
    cidr_block = "13.0.1.0/24"  # Represents all IP addresses (i.e., internet-bound traffic)
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }

  route {
    cidr_block = "14.0.1.0/24"  # Represents all IP addresses (i.e., internet-bound traffic)
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }



  tags = {
    Name = "${var.environment}-rt-1"
  }
}

# configure route table association
resource "aws_route_table_association" "rt-ass-1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt-1.id
}



# Create a key pair
resource "aws_key_pair" "kp-1" {
  key_name = "server-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}


# Create Security group
resource "aws_security_group" "secgrp-1" {
  name        = "secgrp-1"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-1.id

  tags = {
    Name = "secgrp-1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH-1" {
  security_group_id = aws_security_group.secgrp-1.id
  #cidr_ipv4         = aws_vpc.vpc-2.cidr_block
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4-1" {
  security_group_id = aws_security_group.secgrp-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



# Create ec2-1 in vpc-1
resource "aws_instance" "ec2-1" {
  ami = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet-1.id
  key_name = aws_key_pair.kp-1.key_name
  vpc_security_group_ids = [aws_security_group.secgrp-1.id]
  tags = {
    Name = "${var.environment}-ec2-1"
  }

}





# Create a VPC-2 | VPC-2 Configurations
resource "aws_vpc" "vpc-2" {
    cidr_block = var.dev_vpc2_cidr_block
    tags = {
        Name = "${var.environment}-vpc-2"
    }
}

# Create Internet gateway2
resource "aws_internet_gateway" "igw-2" {
  vpc_id = aws_vpc.vpc-2.id
  tags = {
    Name = "${var.environment}-IGW-2"
  }
}

# Create subnet-2 for VPC-2
resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.vpc-2.id
  cidr_block = var.dev_subnet2_cidr_block
  availability_zone = "us-east-1e"
  tags = {
    Name = "${var.environment}-subnet-2"
  }
}

# Create a route table
resource "aws_route_table" "rt-2" {
  vpc_id = aws_vpc.vpc-2.id

  route {
    cidr_block = "0.0.0.0/0"  # Represents all IP addresses (i.e., internet-bound traffic)
    gateway_id = aws_internet_gateway.igw-2.id
  }
  
  route {
    cidr_block = "12.0.1.0/24"  # Represents all IP addresses (i.e., internet-bound traffic)
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }

  route {
    cidr_block = "14.0.1.0/24"  # Represents all IP addresses (i.e., internet-bound traffic)
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }
  tags = {
    Name = "${var.environment}-rt-2"
  }
}

# configure route table association
resource "aws_route_table_association" "rt-ass-2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt-2.id
}



# Create Security group for vpc-2
resource "aws_security_group" "secgrp-2" {
  name        = "secgrp-2"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-2.id

  tags = {
    Name = "secgrp-2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH-2" {
  security_group_id = aws_security_group.secgrp-2.id
  #cidr_ipv4         = aws_vpc.vpc-2.cidr_block
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4-2" {
  security_group_id = aws_security_group.secgrp-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



# Create ec2-2 in vpc-2
resource "aws_instance" "ec2-2" {
  ami = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet-2.id
  key_name = aws_key_pair.kp-1.key_name
  vpc_security_group_ids = [aws_security_group.secgrp-2.id]

  tags = {
    Name = "${var.environment}-ec2-2"
  }

}



# Create a VPC-3 | Configure vpc-3
resource "aws_vpc" "vpc-3" {
    cidr_block = var.dev_vpc3_cidr_block
    tags = {
        Name = "${var.environment}-vpc-3"
    }
}

# Create Internetgateway3
resource "aws_internet_gateway" "igw-3" {
  vpc_id = aws_vpc.vpc-3.id
  tags = {
    Name = "${var.environment}-IGW-3"
  }
}

# Create subnet-3 for VPC-3
resource "aws_subnet" "subnet-3" {
  vpc_id = aws_vpc.vpc-3.id
  cidr_block = var.dev_subnet3_cidr_block
  availability_zone = "us-east-1c"
  tags = {
    Name = "${var.environment}-subnet3"
  }
}

# Create a route table
resource "aws_route_table" "rt-3" {
  vpc_id = aws_vpc.vpc-3.id

  route {
    cidr_block = "0.0.0.0/0"  # Represents all IP addresses (i.e., internet-bound traffic)
    gateway_id = aws_internet_gateway.igw-3.id
  }

  route {
    cidr_block = "12.0.1.0/24"  # Represents all IP addresses (i.e., internet-bound traffic)
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }

  route {
    cidr_block = "13.0.1.0/24"  # Represents all IP addresses (i.e., internet-bound traffic)
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }


  tags = {
    Name = "${var.environment}-rt-3"
  }
}

# configure route table association
resource "aws_route_table_association" "rt-ass-3" {
  subnet_id      = aws_subnet.subnet-3.id
  route_table_id = aws_route_table.rt-3.id
}



# Create Security group for vpc-2
resource "aws_security_group" "secgrp-3" {
  name        = "secgrp-3"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-3.id

  tags = {
    Name = "secgrp-3"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH-3" {
  security_group_id = aws_security_group.secgrp-3.id
  #cidr_ipv4         = aws_vpc.vpc-2.cidr_block
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4-3" {
  security_group_id = aws_security_group.secgrp-3.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # equivalent to all ports
}






# Create ec2-3 in vpc-3
resource "aws_instance" "ec2-3" {
  ami = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet-3.id
  key_name = aws_key_pair.kp-1.key_name
  vpc_security_group_ids = [aws_security_group.secgrp-3.id]
  tags = {
    Name = "${var.environment}-ec2-3"
  }

}



# Create Transit Gateway | Confgiure the main transitgateway
resource "aws_ec2_transit_gateway" "tgw-1" {
    description = "Development Main Transitgateway"

    tags = {
      Name = "${var.environment}-tgw-1"
    }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-1" {
  subnet_ids         = [aws_subnet.subnet-1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  vpc_id             = aws_vpc.vpc-1.id

  tags = {
    Name = "${var.environment}-tgw-att-1"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-2" {
  subnet_ids         = [aws_subnet.subnet-2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  vpc_id             = aws_vpc.vpc-2.id

  tags = {
    Name = "${var.environment}-tgw-att-2"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-3" {
  subnet_ids         = [aws_subnet.subnet-3.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  vpc_id             = aws_vpc.vpc-3.id

  tags = {
    Name = "${var.environment}-tgw-att-3"
  }
}
