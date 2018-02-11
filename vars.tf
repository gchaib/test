variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "subnet_mask_offset" {
  default = "8"
}

variable "env_id" {
  default = "969394324906"
}

variable "availability_zones" {
  type    = "list"
  default = ["us-east-1a", "us-east-1b"]
}

variable "bucket_name" {
  default = "static-website-13948204"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}
