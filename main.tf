# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "vpc_tf" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc_tf"
  }
}
# add subnets to VPC
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "Public Subnet_tf ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "Private Subnet_tf  ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "Project VPC_TF IG"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public tf route table"
  }
}

#add ec2 instance
resource "aws_instance" "ec2_tf" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = "subnet-014c7fe4c09bf5c3d"
  vpc_security_group_ids = ["sg-0695821550184e625"]

  tags = {
    Name = "ec2_tf"
  }
}
