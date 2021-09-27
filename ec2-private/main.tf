provider "aws" {
  region = "ap-southeast-1" 
  profile = "default"
}
module "sg" {
    source = "../module/sg"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
    sg_name = "private_ec2_sg"
    ec2_ingress_ports_default ={
    "22"  = {
        port = 22
        protocol = "tcp" 
        cidr_blocks = ["10.10.10.0/25"]
    }
}
    
}
module "ec2" {
  source = "../module/ec2/"

  name                        = "private-ec2"
  ami                         = "ami-082105f875acab993"
  instance_type               = "t2.micro"
  subnet_id                  = data.terraform_remote_state.vpc.outputs.private_subnets
  #subnet_id                   = "subnet-39d8a960"
  vpc_security_group_ids      = ["${module.sg.sg_id}"]
  key_name                    = "test-suresh"
}

