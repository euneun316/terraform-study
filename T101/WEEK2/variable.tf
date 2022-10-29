variable "tags" {
  type        = list(any)
  default     = ["T101"]
  description = "dditional name tags"
}

variable "account" {
  default = "imok"
}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "aws_az" {
  type    = list(any)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "vpc_cidr" {
  type = string
  # default = "10.0.0.0/16"
  default = "192.0.0.0/16"
}

variable "dev_private_subnet" {
  type = list(any)
  # default = ["10.0.11.0/24", "10.0.12.0/24"]
  default = ["192.0.21.0/24", "192.0.25.0/24"]
}

variable "prd_private_subnet" {
  type = list(any)
  # default = ["10.0.11.0/24", "10.0.12.0/24"]
  default = ["192.0.11.0/24", "192.0.15.0/24"]
}

variable "public_subnet" {
  type = list(any)
  # default = ["10.0.1.0/24", "10.0.2.0/24"]
  default = ["192.0.1.0/24", "192.0.5.0/24"]
}

variable "aws_az_des" {
  type    = list(any)
  default = ["2a", "2c"]
}

variable "imok_alb_ingress_rules" {
  type        = list(map(string))
  default     = []
  description = "bastion sg rule"
}

variable "imok_acm_certi" {
  type        = string
  default     = ""
  description = "acm certi"
}

