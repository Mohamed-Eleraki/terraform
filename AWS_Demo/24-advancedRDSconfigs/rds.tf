# Deploy a subnet group
resource "aws_db_subnet_group" "RDS_sub_group" {
  name = "rds_subnet_group"
  subnet_ids = [aws_subnet.prv_subnet_01.id, aws_subnet.pub_subnet_01.id]

  tags = {
    Name = "rds_subnet_group"
  }

}

# Deploy an RDS instance
resource "aws_db_instance" "rds_postgres_instance" {
  allocated_storage = 20
  engine = "postgres"
  engine_version = "16.3"
  instance_class = "db.t3.micro"
  db_name = "postgresql_database"
  username = "postgres"
  #password = "postgres"
  manage_master_user_password = true
  db_subnet_group_name = aws_db_subnet_group.RDS_sub_group.name
  vpc_security_group_ids = [aws_security_group.secgrp_RDS_01.id]
  skip_final_snapshot = true  # whether or not AWS RDS creates a final snapshot of the database before it is deleted.
  publicly_accessible = false
  storage_encrypted = true
  multi_az = true
  backup_retention_period = 7
  blue_green_update {  # ensuring the Updates applies by AWS applies via Blue/Green deployment
    enabled = true
  }
  tags = {
    Name = "rds_postgres_instance"
  }
}