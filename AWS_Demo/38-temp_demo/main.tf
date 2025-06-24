resource "aws_vpc" "eraki_useast_vpc01" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "eraki-useast-vpc01"
  }
}
