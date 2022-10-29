variable "tags" {
  type        = string
  default     = "imok"
  description = "Additional name tags"
}

variable "account" {
  default = "imok"
}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}