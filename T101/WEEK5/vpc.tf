## vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.tags}-vpc"
  }
}

## Subnet
# public subnet
resource "aws_subnet" "pub_sub" {
  for_each                = var.public_subnet
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.tags}-${each.key}"
  }
}

# dev private subnet
resource "aws_subnet" "dev_pri_sub" {
  for_each                = var.dev_private_subnet
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.tags}-${each.key}"
  }
}

# prd private subnet
resource "aws_subnet" "prd_pri_sub" {
  for_each                = var.prd_private_subnet
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.tags}-${each.key}"
  }
}

## Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.tags}-igw"
  }
}

## Public Routing table and association
resource "aws_route_table" "pub_rt" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_internet_gateway.igw]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.tags}-pub-rt"
  }
}

# pub_rt_association
resource "aws_route_table_association" "pub_rt_association" {
  for_each       = var.public_subnet
  subnet_id      = aws_subnet.pub_sub[each.key].id
  route_table_id = aws_route_table.pub_rt.id
}

## EIP
# nat_eip
resource "aws_eip" "nat_eip" {
  for_each = var.public_subnet
  vpc      = true

  tags = {
    Name = "${var.tags}-nat-${each.value["des"]}-eip"
  }
}

## Nat gateway
resource "aws_nat_gateway" "nat_gw" {
  for_each      = var.public_subnet
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.pub_sub[each.key].id

  tags = {
    Name = "${var.tags}-nat-${each.value["des"]}"
  }
}

## Private Routing table and association
resource "aws_route_table" "pri_rt" {
  for_each   = var.public_subnet
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_nat_gateway.nat_gw]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[each.key].id
  }

  tags = {
    Name = "${var.tags}-pri-rt-${each.value["des"]}"
  }
}

# dev_rt_association
resource "aws_route_table_association" "dev_rt_association" {
  for_each       = var.dev_private_subnet
  subnet_id      = aws_subnet.dev_pri_sub[each.key].id
  route_table_id = aws_route_table.pri_rt[each.value["pri_rt"]].id
}

# prd_rt_association
resource "aws_route_table_association" "prd_rt_association" {
  for_each       = var.prd_private_subnet
  subnet_id      = aws_subnet.prd_pri_sub[each.key].id
  route_table_id = aws_route_table.pri_rt[each.value["pri_rt"]].id
}