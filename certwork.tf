# Template for aws compute cloud
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "certworkkey" {
  key_name = "certworkkey"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7PRHFiNFhIk6CTqA7suAksPaCnqYwcqLUNhkkZq3r2 root@certwork"
}

resource "aws_security_group" "certwork" {
  name = "certwork"
  description = "open 22 ssh, 8080 ports for tomcat"
  vpc_id = "vpc-06522b293159a2cd7"

  ingress {
    description = "only for tomcat pages"
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ssh only for me"
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["158.160.55.244/32"]
  }

  egress {
    description = "allow all to outside"
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "certwork-build" {
  ami = "ami-09cd747c78a9add63"
  instance_type = "t2.micro"
  key_name = "certworkkey"
  vpc_security_group_ids = ["${aws_security_group.certwork.id}"]
  subnet_id = "subnet-0414e6106afcc7dec"
  tags = {
    Name = "certwork-build"
  }
}

resource "aws_instance" "certwork-prod" {
  ami = "ami-09cd747c78a9add63"
  instance_type = "t2.micro"
  key_name = "certworkkey"
  vpc_security_group_ids = ["${aws_security_group.certwork.id}"]
  subnet_id = "subnet-0414e6106afcc7dec"
  tags = {
    Name = "certwork-prod"
  }
}

#resource "local_file" "vmaddresses" {
#  content = "{ \"building_ip_address\" : \"${aws_instance.certwork-build.public_ip}\", \"production_ip_address\" : \"${aws_instance.certwork-prod.public_ip}\"}"
#  filename = "./ip_addresses.json"
#}