provider "aws" {
  region = "ap-southeast-1" 
  profile = "default"
}
provider "aws" {
  alias  = "peer"
  region = local.accept_region
}
data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
      bucket = "terraform-state-backupend"
      key = "vpc"
      region = "ap-southeast-1"
    }
}
module "vpc" {
  source = "../module/vpc"
  name   = "vpc2-poc"
  #env    = "${var.env}"
  vpc_cidr_block = "10.10.11.0/24"
  #public_subnets = [ "10.10.10.0/25"]
  private_subnets = ["10.10.11.0/24"]
  use_nat = false
  create_peering = true
  destination_cidr_block ="10.10.10.0/24"
  source_id = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_tags= {
    Terraform = "true"
    vpc = "main-vpc"
  }
  public_route_table_tags= {
    Name = "pubic-route"
  }
}






