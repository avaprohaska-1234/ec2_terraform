terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "vpc_tf" {
  cidr_block = "10.0.0.0/16"
}

#add ec2 instance
resource "aws_instance" "ec2_tf" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  tags = {
    Name = "ec2_tf"
  }
}
