variable "tags" {
  type        = string
  default     = "imok-corp"
  description = "Additional company tags"
}

variable "env" {
  type        = list(any)
  default     = ["dev", "prd"]
  description = "Additional env tags"
}

variable "server" {
  type        = list(any)
  default     = ["service", "management"]
  description = "server name"
}

variable "service_server_port" {
  type    = list(any)
  default = [8085, 8086]
}

variable "management_server_port" {
  type    = list(any)
  default = [8080]
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

variable "acm_certi" {
  type    = string
  default = ""
}

variable "bastion_ingress_rules" {
  type        = list(map(string))
  default     = []
  description = "bastion sg rule"
}

variable "service_ingress_rules" {
  type        = list(map(string))
  default     = []
  description = "service sg rule"
}

variable "management_ingress_rules" {
  type        = list(map(string))
  default     = []
  description = "management sg rule"
}