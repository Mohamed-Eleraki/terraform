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

# variable Section

variable "environment" {}

 
# Resources Section
resource "aws_ec2_transit_gateway" "tgw-1" {
    default_route_table_association = "enable"
    default_route_table_propagation = "enable"
    dns_support = "enable"
    vpn_ecmp_support = "enable"
    
    tags = {
        Name = "${var.environment}-tgw-1"
    }
}

# Create TransitGateway Route table
resource "aws_ec2_transit_gateway_route_table" "tgw-rt-1" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
}

# attach vpc to transitgateway
resource "aws_ec2_transit_gateway_vpc_attachment" "example_vpc_attachment" {
  vpc_id             = "your-vpc-id"  # Replace with your actual VPC ID
  subnet_ids         = ["your-subnet-id-1", "your-subnet-id-2"]  # Replace with your actual subnet IDs
  transit_gateway_id = aws_ec2_transit_gateway.example_tgw.id

  // Additional options can be specified here
}


# Create Transit Gateway Route for tgw-1
resource "aws_ec2_transit_gateway_route" "example_route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
}

# AWS RAM  resource association for TGW attachment to Shared Network
resource "aws_ram_resource_share" "RAM-1" {
    name =  "${var.environment}-TGW-SharedNetwork"
    allow_external_principals = true

    tags = {
        Name = "${var.environment}-TGW-SharedNetwork-Tag"
    }
}

resource "aws_ram_resource_association" "RAM-association" {
    resource_arn = aws_ec2_transit_gateway.tgw-1.arn
    resource_share_arn = aws_ram_resource_share.RAM-1.arn
}

resource "aws_ram_principal_association" "RAM-Prencipal_association" {
  principal = "89132503" # Account ID
  resource_share_arn = aws_ram_resource_share.RAM-1.arn
}


# Output Section
output "tgw-1_Output-ID" {
  value = aws_ec2_transit_gateway.tgw-1.id
}

output "tgw-1_Output-aws_ec2_transit_gateway" {
  value = aws_ec2_transit_gateway.tgw-1.arn
}

output "tgw-1_Output-routeTable" {
  value = aws_ec2_transit_gateway.tgw-1.association_default_route_table_id
}

output "tgw-1_Output-routeTablePropagation" {
  value = aws_ec2_transit_gateway.tgw-1.propagation_default_route_table_id
}

output "tgw-1_Output-dnsSupport" {
  value = aws_ec2_transit_gateway.tgw-1.dns_support
}

output "tgw-1_Output-Tags" {
  value = aws_ec2_transit_gateway.tgw-1.tags_all
}

output "tgw-1_Output-multiPathing" {
  value = aws_ec2_transit_gateway.tgw-1.vpn_ecmp_support
}

output "RAM-resouce_share-ID" {
  value = aws_ram_resource_share.RAM-1.id
}