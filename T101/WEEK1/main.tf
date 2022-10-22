# amazon linux2 ami latest
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    # values = ["amzn2-ami-hvm*"]
    values = ["amzn2-ami-hvm-*-gp2"]
}
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# amazon linux2 ami latest kernel-5
data "aws_ami" "amazon-linux-2-kernel-5" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5*"]
  }
}

# ubuntu ami latest
data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["099720109477"] # Canonical(owner account id)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    # values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-18.04-amd64-server-*"]
    # values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-22.04-arm64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

provider "aws" {
	region  = var.region
	profile = var.account
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.tags[0]}-vpc"
  }
}

# public subnet
resource "aws_subnet" "pub-sub" {
  count                   = length(var.aws_az)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = var.aws_az[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.tags[0]}-public-subnet-${var.aws_az_des[count.index]}"
  }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.tags[0]}-igw"
  }
}

# public route table
resource "aws_route_table" "pub_rt" {
  count      = length(var.aws_az)
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.tags[0]}-public-rt-${var.aws_az_des[count.index]}"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Assign the public route table to the public subnet
resource "aws_route_table_association" "public-rt-association" {
  count          = length(aws_route_table.pub_rt)
  subnet_id      = element(aws_subnet.pub-sub.*.id, count.index)
  route_table_id = element(aws_route_table.pub_rt.*.id, count.index)
}

# EIP and association
resource "aws_eip" "eip" {
  instance = aws_instance.T101.id
  vpc      = true
  
  tags = {
    Name = "${var.tags[0]}-eip"
  }
}

# instance
resource "aws_instance" "T101" {
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id              = element(aws_subnet.pub-sub.*.id, 0)

  user_data = <<-EOF
              #!/bin/bash
              echo "imok server - T101 Study test" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  user_data_replace_on_change = true 

  root_block_device {
    volume_type = "gp3"
    volume_size = "20"
  }

  tags = {
    Name = "${var.tags[0]}-instance"
  }       
}

# security_group
resource "aws_security_group" "instance" {
  name = var.security_group_name
  vpc_id = aws_vpc.vpc.id

  # inbound rule
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # outbound rule
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "All"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.tags[0]}-sg"
  }
}