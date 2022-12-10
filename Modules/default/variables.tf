# env - e.g: dev|prd|stage
variable "environment" {}

# Region - e.g: ap-northeast-2
variable "region" {}

# project name
variable "name" {}

# EC2 instance type
variable "ec2_type_public" {}
variable "ec2_type_private" {}

# EC2 volume size
variable "ec2_volume_size" {}

# EC2 termination protection
variable "instance_disable_termination" {}

# VPC default CIDR
variable "vpc_cidr" {}

# Availability Zones
variable "az_names" {}

# public subnet list
variable "public_subnets" {}

# private subnet list
variable "private_subnets" {}

# Tag
variable "tags" {}

# public ingress IP list
variable "public_ingress_rules" {}

# private ingress IP list
variable "private_ingress_rules" {}

# DB port
variable "db_port" {}

