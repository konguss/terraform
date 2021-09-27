
provider "aws" {
  region = "ap-southeast-1" 
  profile = "default"
}
module "sg" {
    source = "../module/sg"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
    sg_name = "test_sg"
   ec2_ingress_ports_default ={
    "22"  = {
        port = 22
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
    }
    "80"  = {
        port = 80
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
    }
}
    
}
  