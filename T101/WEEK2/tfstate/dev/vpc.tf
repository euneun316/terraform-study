## vpc
resource "aws_vpc" "imok_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.tags[0]}-vpc"
  }
}

## Subnet
# public subnet
resource "aws_subnet" "imok_pub_sub" {
  count                   = length(var.aws_az)
  vpc_id                  = aws_vpc.imok_vpc.id
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = var.aws_az[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.tags[0]}-pub-sub-${var.aws_az_des[count.index]}"
  }
}

# dev private subnet
resource "aws_subnet" "imok_dev_pri_sub" {
  count                   = length(var.aws_az)
  vpc_id                  = aws_vpc.imok_vpc.id
  cidr_block              = var.dev_private_subnet[count.index]
  availability_zone       = var.aws_az[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.tags[0]}-dev-pri-sub-${var.aws_az_des[count.index]}"
  }
}

# prd private subnet
resource "aws_subnet" "imok_prd_pri_sub" {
  count                   = length(var.aws_az)
  vpc_id                  = aws_vpc.imok_vpc.id
  cidr_block              = var.prd_private_subnet[count.index]
  availability_zone       = var.aws_az[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.tags[0]}-prd-pri-sub-${var.aws_az_des[count.index]}"
  }
}

## Internet gateway
resource "aws_internet_gateway" "imok_igw" {
  vpc_id = aws_vpc.imok_vpc.id

  tags = {
    Name = "${var.tags[0]}-igw"
  }
}

## Public Routing table and association
resource "aws_route_table" "imok_pub_rt" {
  vpc_id     = aws_vpc.imok_vpc.id
  depends_on = [aws_internet_gateway.imok_igw]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.imok_igw.id
  }

  tags = {
    Name = "${var.tags[0]}-pub-rt"
  }
}

# pub_rt_association
resource "aws_route_table_association" "imok_pub_rt_association" {
  count          = length(aws_route_table.imok_pub_rt)
  subnet_id      = element(aws_subnet.imok_pub_sub.*.id, count.index)
  route_table_id = aws_route_table.imok_pub_rt.id
}

## EIP
# nat_eip
resource "aws_eip" "imok_nat_eip" {
  count = length(var.aws_az)
  vpc   = true

  tags = {
    Name = "${var.tags[0]}-nat-${var.aws_az_des[count.index]}-eip"
  }
}

## Nat gateway
resource "aws_nat_gateway" "imok_nat_gw" {
  count         = length(var.aws_az)
  allocation_id = aws_eip.imok_nat_eip[count.index].id
  subnet_id     = aws_subnet.imok_pub_sub[count.index].id

  tags = {
    Name = "${var.tags[0]}-nat-${var.aws_az_des[count.index]}"
  }
}

## Private Routing table and association
resource "aws_route_table" "imok_pri_rt" {
  count      = length(var.aws_az)
  vpc_id     = aws_vpc.imok_vpc.id
  depends_on = [aws_nat_gateway.imok_nat_gw]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.imok_nat_gw[count.index].id
  }

  tags = {
    Name = "${var.tags[0]}-pri-rt-${var.aws_az_des[count.index]}"
  }
}

# dev_rt_association
resource "aws_route_table_association" "imok_dev_rt_association" {
  count          = length(var.aws_az)
  subnet_id      = element(aws_subnet.imok_dev_pri_sub.*.id, count.index)
  route_table_id = element(aws_route_table.imok_pri_rt.*.id, count.index)
}

# prd_rt_association
resource "aws_route_table_association" "imok_prd_rt_association" {
  count          = length(var.aws_az)
  subnet_id      = element(aws_subnet.imok_prd_pri_sub.*.id, count.index)
  route_table_id = element(aws_route_table.imok_pri_rt.*.id, count.index)
}