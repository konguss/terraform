provider "aws" {
  region  = "ap-southeast-1"
  profile = "default"
}
module "sg" {
  source  = "../module/sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_name = "bastion_sg"
  ec2_ingress_ports_default = {
    "3306" = {
      port        = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.10.10.0/25"]
    }
  }
}

module "mysql" {
  source            = "../module/rds"
  name  = "my-sql-db"
  instance_class    = "db.t2.medium"
  allocated_storage = 10
  subnet_ids = ["subnet-05a5d2c83c74b0fc9", "subnet-0b3f63bd1e29ae71c"]
  #subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnets
  # Change to valid security group id
  vpc_security_group_ids = ["${module.sg.sg_id}"
  ]

  # Change to valid parameter group name
  parameter_group_name    = "default.mysql5.7"
  subnet_group_name       = "mysql-subnet-group"
  maintenance_window      = "Sun:02:00-Sun:03:00"
  backup_window           = "00:00-01:00"
  backup_retention_period = 10
  dbname = "mysqldb"
   db_tag= {
    Terraform = "true"
    Name = "my-sql"
  }
}