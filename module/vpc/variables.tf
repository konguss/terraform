variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}
variable "vpc_cidr_block" {
  description = "VPC cidr block"
}
variable "name" {}
#variable "env" {}
variable "azs" {
  description = "A List of Avilability azs in the region"
  default = ["ap-southeast-1a", "ap-southeast-1b" ]
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}
variable "private_route"{
 description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "use_nat" {
  default = true
}
variable "create_route" {
  default = true
}
variable "public_route_table_tags" {
  type= map(string)
  default = {
  }
}
variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}
variable "private_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "private"
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  type        = bool
  default     = true
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "create_peering" {
   description = "Controls if VPC should be created (it affects almost all resources)"
   type        = bool
   default     = false
  
}
variable "source_id" {
  description = "Source VPC id"
  type = string
  default = ""
}
variable "region" {
  description = "AWS region"
  type = string
  default = "ap-southeast-1"
  
}
variable "public_subnet_tag" {
  description = "tags for public subnet"
  type= map(string)
  default = {
    Name = "public-subnet"
    }
  }
variable "private_subnet_tag" {
  description = "tags for public subnet"
  type= map(string)
  default = {
    Name = "private-subnet"
    }
  }
  variable "destination_cidr_block"  {
    type= string
    default=" "
  }