variable "name" {
  description = "The name used to namespace all the resources created by this module"
  type        = string
  default     = "github-iam-role-example"
}

variable "tags" {
  type        = string
  default     = "imok-corp"
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
