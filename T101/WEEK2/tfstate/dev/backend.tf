terraform {
  backend "s3" {
    bucket = "imok-t101study-tfstate"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}
