provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_s3_bucket" "tf_demo" {
  bucket = "mohit0920-tf-demo"
  acl    = "private"
}
