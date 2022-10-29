resource "aws_s3_bucket" "imok_s3bucket" {
  bucket = "${var.tags}-t101study-tfstate"
}

# Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "mys3bucket_versioning" {
  bucket = aws_s3_bucket.imok_s3bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}