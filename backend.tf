terraform {
  required_version = ">=0.11.3"

  backend "s3" {
    bucket = "bucket-challenge"
    key    = "v1/v1.tfstate"
    region = "us-east-1"
  }
}
