terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-799e3fcf55d95ddd7d196007188560cbc191161f"
    key            = "terraform-sandbox.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_locks"
  }
}
