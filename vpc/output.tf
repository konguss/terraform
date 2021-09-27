#output "private_subnet_ids" {
#  value = ["${aws_subnet.private.*.id}"]
#}
#output "public_subnet_ids" {
 # value = "$module.vpc.public_subnet_ids"
#}
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
output "public_subnets" {
  description = "List of Ids of public subnets"
  value = module.vpc.public_subnets 
}

output "private_subnets" {
  description = "List of Ids of public subnets"
  value = module.vpc.public_subnets 
}

output "peering_id" {
  description= "peering connection id"
  value = module.vpc.peering_id  
}
