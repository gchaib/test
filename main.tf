module "roles" {
  source = "modules/roles"
}

module "network" {
  source               = "./modules/network"
  vpc_name             = "VPC_Terraform"
  vpc_cidr             = "${var.vpc_cidr}"
  region               = "${var.AWS_REGION}"
  availability_zones   = "${var.availability_zones}"
  public_subnets_cidr  = ["${cidrsubnet("${var.vpc_cidr}","${var.subnet_mask_offset}",100)}", "${cidrsubnet("${var.vpc_cidr}","${var.subnet_mask_offset}",101)}"]
  private_subnets_cidr = ["${cidrsubnet("${var.vpc_cidr}","${var.subnet_mask_offset}",0)}", "${cidrsubnet("${var.vpc_cidr}","${var.subnet_mask_offset}",1)}"]
}

module "cloudfront" {
  source     = "modules/cloudfront/"
  bucket_dns = "${module.s3.bucket_dns}"
}

module "s3" {
  source      = "modules/s3/"
  bucket_name = "${var.bucket_name}"
}
