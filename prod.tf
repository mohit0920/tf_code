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

resource "aws_default_subnet" "default_az1" {
  availability_zone = "ap-northeast-1a"
  
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "ap-northeast-1a"

  tags = {
    "Terraform": "true"
  } 
}
  

resource "aws_elb" "prod_web" {
  name 		  = "prod-web"
  subnets 	  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups = [aws_security_group.prod_web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port	      = 80
    lb_protocol       = "http"
  }

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_launch_template" "prod_web" {
  name_prefix   = "prod_web"
  image_id      = "ami-03d1df84cc2b788cf"
  instance_type = "t2.micro"
  tags = {
    key = "Terraform"
    value =  "true"
    propagate_at_launch = true
  } 
}

resource "aws_autoscaling_group" "prod_web" {
  availability_zones  = ["ap-northeast-1a", "ap-northeast-1a"]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.prod_web.id
    version = "$Latest"
  } 
}

resource "aws_autoscaling_attachment" "prod_web" {
  autoscaling_group_name = aws_autoscaling_group.prod_web.id
  elb                    = aws_elb.prod_web.id
}
