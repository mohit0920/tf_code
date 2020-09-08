provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}


resource "aws_default_vpc" "default_vpc" {}

resource "aws_security_group" "prod_web" {
  name = "prod_web"
  description = "Allow standard http and https ports ingress and all traffic outboud"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
  }
}
  
resource "aws_instance" "prod_web" {
  count = 2  

  ami = "ami-03d1df84cc2b788cf"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_eip_association" "prod_web" {
  instance_id = aws_instance.prod_web[0].id
  allocation_id = aws_eip.prod_web.id
}

resource "aws_eip" "prod_web" {

  tags = {
    "Terraform" : "true"
  }
}

