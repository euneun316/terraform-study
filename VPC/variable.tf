variable "aws_az" {
  type = list
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "vpc_cidr" {
  type = string
  # default = "10.0.0.0/16"
  default = "192.0.0.0/16"
}

variable "dev_private_subnet" {
  type = list
  # default = ["10.0.11.0/24", "10.0.12.0/24"]
  default = ["192.0.21.0/24", "192.0.25.0/24"]
}

variable "prd_private_subnet" {
  type = list
  # default = ["10.0.11.0/24", "10.0.12.0/24"]
  default = ["192.0.11.0/24", "192.0.15.0/24"]
}

variable "public_subnet" {
  type = list
  # default = ["10.0.1.0/24", "10.0.2.0/24"]
  default = ["192.0.1.0/24", "192.0.5.0/24"]
}

variable "aws_az_des" {
  type = list
  default = ["2a", "2c"]
}