locals {
    name = "eraki"
    environment = "dev"
    region = "us-east-1"
    instance_name = "ec2_01"

    common_tags = {
        serviceAccount = "terraform"
    }
}