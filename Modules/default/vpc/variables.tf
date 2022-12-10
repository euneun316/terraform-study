# env - e.g: dev|prd|stage
# variable "environment" {}

# project name
variable "name" {}

# VPC default CIDR
variable "vpc_cidr" {}

# Availability Zones
variable "az_names" {}

# public subnet list
variable "public_subnets" {}

# private subnet list
variable "private_subnets" {}

# Tags
variable "tags" {}