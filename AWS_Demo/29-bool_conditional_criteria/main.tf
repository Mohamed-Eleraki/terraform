resource "aws_instance" "ec2_01" {
  count                       = (var.high_availability == true ? 3 : 1)
  ami                         = "ami-0a3c3a20c09d6f377"
  instance_type               = "t2.micro"
  #associate_public_ip_address = (count.index == true ? true : false)
  associate_public_ip_address = (count.index == 0 ? true : false)  # 0 means true
  tags                        = merge(local.common_tags)
  #tags                        = local.common_tags
}

resource "random_id" "id" {
  byte_length = 8
}

output "assciate_public_ip_value" {
  value = [ for instance in aws_instance.ec2_01 : instance.associate_public_ip_address ]
  #value = aws_instance.ec2_01.associate_public_ip_address
}