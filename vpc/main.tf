provider "aws" {
  region = "ap-southeast-1" 
  profile = "default"
}
module "vpc" {
  source = "../module/vpc"
  name   = "vpc-poc"
  #env    = "${var.env}"
  vpc_cidr_block = "10.10.10.0/24"
  public_subnets = [ "10.10.10.0/25"]
  private_subnets = ["10.10.10.128/26", "10.10.10.224/27"]
  vpc_tags= {
    Terraform = "true"
    vpc = "main-vpc"
  }
  public_route_table_tags= {
    Name = "pubic-route"
  }
}






