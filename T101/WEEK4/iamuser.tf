provider "aws" {
  region = "ap-northeast-2"
}

locals {
  name = "mytest"
  team = {
    group = "dev"
  }
}

resource "aws_iam_user" "myiamuser1" {
  name = "${local.name}1"
  tags = local.team
}

resource "aws_iam_user" "myiamuser2" {
  name = "${local.name}2"
  tags = local.team
}
