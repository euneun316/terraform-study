#####################
# Terraform setting

environment = "dev"
region      = "ap-northeast-2"

tags = {
  MadeBy = "imok"
}

#####################
# Project name

name = "T101"

#####################
# Network setting 

vpc_cidr = "10.60.0.0/16"

az_names = [
  "ap-northeast-2a",
  "ap-northeast-2c"
]

public_subnets = {
  pub_sub_2a = {
    zone = "ap-northeast-2a"
    cidr = "10.60.0.0/24"
  },
  pub_sub_2c = {
    zone = "ap-northeast-2c"
    cidr = "10.60.1.0/24"
  }
}

private_subnets = {
  pri_sub_2a = {
    zone = "ap-northeast-2a"
    cidr = "10.60.2.0/24"
  },
  pri_sub_2c = {
    zone = "ap-northeast-2c"
    cidr = "10.60.3.0/24"
  }
}

#####################
# Instance setting

instance_disable_termination = true

ec2_type_public  = "t3.micro"
ec2_type_private = "t3.micro"
ec2_volume_size  = 30


#########################
# Secret Groups setting

public_ingress_rules = [
  {
    from_port = "22",
    to_port   = "22",
    cidr      = "151.149.23.124/32"
    desc      = "From Imok SSH(random test ip)"
  },
  {
    from_port = "3389",
    to_port   = "3389",
    cidr      = "151.149.23.124/32"
    desc      = "From Imok RDP(random test ip)"
  }
]

private_ingress_rules = [
  {
    from_port = "22",
    to_port   = "22",
    cidr      = "151.149.23.124/32"
    desc      = "From Imok SSH(random test ip)"
  },
  {
    from_port = "3389",
    to_port   = "3389",
    cidr      = "151.149.23.124/32"
    desc      = "From Imok RDP(random test ip)"
  }
]

db_port = "3306"
