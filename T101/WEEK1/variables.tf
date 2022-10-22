variable "server_port" {
  type        = number
  default     = 8080
  description = "The port the server will use for HTTP requests"
}

variable "tags" {
  type = list
  default = ["t101","dev"]
  description = "Additional resource tags"
}

variable "account" {
  default = "imok"
}

variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "aws_az" {
 type = list
 default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "private_subnet" {
  type = list
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "public_subnet" {
  type = list
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "aws_az_des" {
 type = list
 default = ["2a", "2c"]
}

variable "security_group_name" {
  type        = string
  default     = "t101-sg"
  description = "The name of the security group"
}