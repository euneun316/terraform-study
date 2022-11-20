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

variable "vpc_cidr" {
  type    = string
  default = "10.60.0.0/16"
}

variable "dev_private_subnet" {
  type = map(any)
  default = {
    dev-pri-sub-2a = {
      az     = "ap-northeast-2a"
      cidr   = "10.60.0.0/24"
      des    = "2a"
      pri_rt = "pub-sub-2a"
    }
    dev-pri-sub-2c = {
      az     = "ap-northeast-2c"
      cidr   = "10.60.1.0/24"
      des    = "2c"
      pri_rt = "pub-sub-2c"
    }
  }
}

variable "prd_private_subnet" {
  type = map(any)
  default = {
    prd-pri-sub-2a = {
      az     = "ap-northeast-2a"
      cidr   = "10.60.2.0/24"
      des    = "2a"
      pri_rt = "pub-sub-2a"
    }
    prd-pri-sub-2c = {
      az     = "ap-northeast-2c"
      cidr   = "10.60.3.0/24"
      des    = "2c"
      pri_rt = "pub-sub-2c"
    }
  }
}

variable "public_subnet" {
  type = map(any)
  default = {
    pub-sub-2a = {
      az   = "ap-northeast-2a"
      cidr = "10.60.4.0/24"
      des  = "2a"
    }
    pub-sub-2c = {
      az   = "ap-northeast-2c"
      cidr = "10.60.5.0/24"
      des  = "2c"
    }
  }
}