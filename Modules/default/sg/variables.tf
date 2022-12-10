# Project name
variable "name" {}

# Tags
variable "tags" {}

# public ingress IP list
variable "public_ingress_rules" {}

# private ingress IP list
variable "private_ingress_rules" {}

# From module VPC
variable "vpc_id" {}
