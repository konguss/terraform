locals {
  username = var.username 
  password = random_id.password.hex
}
resource "random_id" "password" {
  byte_length = 8
}

resource "aws_db_subnet_group" "dbsubnet" {
  name       = var.subnet_group_name
  subnet_ids = [var.subnet_ids[0], var.subnet_ids[1]]

  tags = {
    Name = "My DB subnet group"
  }
} 
resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}
 resource "aws_db_instance" "mysql" {
    lifecycle {
    ignore_changes = [
      username,
      password,
      snapshot_identifier
    ]
  }
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.dbname
  username             = local.username
  password             = local.password
  parameter_group_name = aws_db_parameter_group.default.name
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.dbsubnet.id
  multi_az = var.multi_az
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window
  backup_retention_period = var.backup_retention_period
  vpc_security_group_ids = var.vpc_security_group_ids
   tags = merge(
  {
    "Name" = format("%s", var.name)
  },
  var.tags,
  var.db_tag,
  )
}