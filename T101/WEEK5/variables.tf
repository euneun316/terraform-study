variable "tags" {
  type        = string
  default     = "T101"
  description = "Additional company tags"
}


variable "account" {
  default     = "imok"
  description = "aws account"
}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "aws_az" {
  type    = list(any)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "aws_az_des" {
  type    = list(any)
  default = ["2a", "2c"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.60.0.0/16"
}

variable "dev_private_subnet" {
  type    = list(any)
  default = ["10.60.0.0/24", "10.60.1.0/24"]
}

variable "prd_private_subnet" {
  type    = list(any)
  default = ["10.60.2.0/24", "10.60.3.0/24"]
}

variable "public_subnet" {
  type    = list(any)
  default = ["10.60.4.0/24", "10.60.5.0/24"]
}