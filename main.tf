terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    bigip = {
      source  = "f5networks/bigip"
      version = "~> 1.9.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
provider "bigip" {
  # this is a hack to auth to a bigip even though we are deploying via bigiq
  address  = var.bigip_address
  username = var.bigip_username
  password = var.bigip_password
}