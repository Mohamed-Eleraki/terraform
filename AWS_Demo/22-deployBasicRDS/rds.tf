resource "aws_db_subnet_group" "db_sub_grp" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.subnet-01.id, aws_subnet.subnet-02.id]

  tags = {
    Name = "db_sub_grp"
  }
}

resource "aws_db_instance" "rds_postgress_01" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  db_name                = "postgresqldatabase"
  username               = "postgres"
  password               = "postgres"
  db_subnet_group_name   = aws_db_subnet_group.db_sub_grp.name
  vpc_security_group_ids = [aws_security_group.secgrp-01.id]
  skip_final_snapshot    = true
  multi_az = false
  publicly_accessible = true

  tags = {
    Name = "rds_postgress_01"
  }

}