variable "azs" {
  description = "A list of Availabity azs in the region"
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}


variable "tags" {
  default = {
  }
}
#variable "env" {
 # default = "prd"
#}
#variable "private_subnets" {
#  default = ["10.0.2.0/24","10.0.3.0/24"]
#}

#variable "vpc_cidr_block" {
 #   default = []  
#}