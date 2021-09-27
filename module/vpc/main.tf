locals {
  
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc.vpc.*.id,
      [""],
    ),
    0,
  )
}


resource "aws_vpc" "vpc" {
  count = var.create_vpc ? 1 : 0
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  tags = merge(
  {
    "Name" = format("%s", var.name)
  },
  var.tags,
  var.vpc_tags,
  )
}
resource "aws_eip" "nat_eip" {
  count = "${var.use_nat ? length(var.azs): 0 }"
  #count = 1
  vpc = true
}
########################################
# Internet gateway
########################################
resource "aws_internet_gateway" "internet_gw" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id
  tags = merge(
  {
    "Name" = format("%s", var.name)
  },
  var.tags,
  var.vpc_tags,
  )
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc[0].id
  count = "${length(var.azs)}"
  tags = merge(
  {
    "Name" = format("%s", var.name)
  },
  var.tags,
  var.private_route,
  )
}
resource "aws_route" "peering" {
  count = var.create_peering ? 1 : 0
  route_table_id            = aws_route_table.private[0].id
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  depends_on                = [aws_route_table.private]
}
resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id   = var.source_id
  count = var.create_peering ? 1 : 0
  vpc_id        = aws_vpc.vpc[0].id
  peer_region   = var.region
  auto_accept= true
}
/*resource "aws_vpc_peering_connection_accepter" "peer" {
  count = var.create_peering ? 1 : 0
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
*/
resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  tags = merge(
    {
      "Name" = format("%s-${var.public_subnet_suffix}", var.name)
    },
    var.tags,
    var.public_route_table_tags,
  )
}
resource "aws_subnet" "public" {
  #count = var.create_vpc && length(var.public_subnets)>0 ?1 : 0 
  vpc_id = aws_vpc.vpc[0].id
  cidr_block = "${var.public_subnets[count.index]}"
  availability_zone = "${element(var.azs,count.index )}"
  count = "${length(var.public_subnets)}"
  tags = merge(
  {
    "Name" = format("%s-${var.public_subnet_suffix}", var.name)
  },
  var.tags,
  var.public_subnet_tag,
  )
}
resource "aws_subnet" "private" {
  cidr_block = "${var.private_subnets[count.index]}"
  vpc_id = aws_vpc.vpc[0].id
  availability_zone = "${element(var.azs, count.index )}"
  count = "${length(var.private_subnets)}"
  tags = merge(
  {
    "Name" = format("%s-${var.private_subnet_suffix}", var.name)
  },
  var.tags,
  var.private_subnet_tag,
  )
}
resource "aws_route_table_association" "public" {
  count = "${var.create_route ? length(var.public_subnets): 0 }"
  subnet_id = "${element(aws_subnet.public.*.id, count.index )}"
  route_table_id = aws_route_table.public[0].id
}
resource "aws_route_table_association" "private" {
  count = "${var.create_route ? length(var.private_subnets): 0 }"
  subnet_id = "${element(aws_subnet.private.*.id, count.index )}"
  route_table_id = aws_route_table.private[0].id
}
resource "aws_nat_gateway" "natgw" {
  count = "${var.use_nat ? length(var.azs): 0 }"
  allocation_id = "${element(aws_eip.nat_eip.*.id,count.index )}"
  subnet_id = "${element(aws_subnet.public.*.id,count.index)}"
  depends_on = [aws_internet_gateway.internet_gw]
  lifecycle {
    ignore_changes = [allocation_id]
  }
}
resource "aws_route" "natgw_route" {
  count = "${var.use_nat ? length(var.azs):0 }"
  route_table_id = "${element(aws_route_table.private.*.id,count.index )}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [aws_route_table.private]
  nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
}

resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gw[0].id

  timeouts {
    create = "5m"
  }
}
