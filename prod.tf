provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_s3_bucket" "prod_tf_s3_demo" {
  bucket = "mohit0920-prod-tf-demo"
  acl    = "private"
}

resource "aws_default_vpc" "default_vpc" {}
