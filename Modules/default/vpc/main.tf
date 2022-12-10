######################################
## vpc

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = format("%s-vpc", var.name)
    },
    var.tags
  )
}


######################################
## Subnet

# public subnet
resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["zone"]
  # AUTO-ASIGN PUBLIC IP
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = format(
        "%s-pub-sub-%s",
        var.name,
        element(split("_", each.key), 2)
      )
    },
    var.tags,
  )
}

# private subnet
resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["zone"]

  tags = merge(
    {
      Name = format(
        "%s-pri-sub-%s",
        var.name,
        element(split("_", each.key), 2)
      )
    },
    var.tags,
  )
}


######################################
## Public route table and association

# public route table
resource "aws_route_table" "public" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_internet_gateway.this]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    {
      Name = format(
        "%s-pub-rt",
        var.name,
      )
    },
    var.tags,
  )
}

# public route association
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}


######################################
## Private route table and association

# private route table
resource "aws_route_table" "private" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_nat_gateway.nat_gw]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = merge(
    {
      Name = format(
        "%s-pri-rt",
        var.name,
      )
    },
    var.tags,
  )
}

# private route association
resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}


######################################
## Internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = format("%s-igw", var.name)
    },
    var.tags
  )
}


######################################
## Nat gateway

# nat eip
resource "aws_eip" "nat" {
  vpc = true

  tags = merge(
    {
      Name = format(
        "%s-nat-eip-%s",
        var.name,
        element(split("-", var.az_names[0]), 2)
      )
    },
    var.tags
  )
}

# nat gateway
# aws_iam_user.example1["user2"].name
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["pub_sub_2a"].id

  tags = merge(
    {
      Name = format(
        "%s-nat-%s",
        var.name,
        element(split("-", var.az_names[0]), 2)
      )
    },
    var.tags
  )
}



