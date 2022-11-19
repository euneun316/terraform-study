provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "myiam" {
  for_each = toset(var.user_names)
  name     = each.value
}
