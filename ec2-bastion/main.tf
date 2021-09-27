provider "aws" {
  region = "ap-southeast-1" 
  profile = "default"
}
data "template_file" "myuserdata" {
  template = "${file("userdata.tpl")}"
}
module "sg" {
    source = "../module/sg"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
    sg_name = "bastion_sg1"
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
module "ec2" {
  source = "../module/ec2/"

  name                        = "example"
  ami                         = "ami-082105f875acab993"
  instance_type               = "t2.micro"
  user_data = "${data.template_file.myuserdata.template}"
  subnet_id                  = data.terraform_remote_state.vpc.outputs.public_subnets
  #subnet_id                   = "subnet-39d8a960"
  vpc_security_group_ids      = ["${module.sg.sg_id}"]
  key_name                    = "test-suresh"
  associate_public_ip_address = true
}

