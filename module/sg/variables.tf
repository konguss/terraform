variable "ec2_ingress_ports_default" {
    type = map(object({
      port= number
      protocol = string
      cidr_blocks=list(string)
    }))
    default = {
}

}
variable "sg_name" {
  description = "Security group name"
  type = string
  default = ""
  
}
variable "vpc_id" {
  description = "Security group name"
  type = string
  default = ""
  
}
