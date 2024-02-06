locals {
  vpc_cidr_blocks = [for i in range(3) : format("10.0.%d.0/24", i)]
}
