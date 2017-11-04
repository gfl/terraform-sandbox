resource "aws_s3_bucket" "my_bucket" {
  bucket = "org-gfl-test-bucket"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }
}