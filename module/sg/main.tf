resource "aws_security_group" "ec2_rules" {
  name = var.sg_name
  vpc_id = var.vpc_id
  dynamic ingress {
    for_each = var.ec2_ingress_ports_default
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      cidr_blocks = ingress.value.cidr_blocks
      protocol    = ingress.value.protocol
    }
  }
   egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
}