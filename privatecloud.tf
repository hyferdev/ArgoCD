provider "aws" {
  region = "us-west-2"
}

# VPC info
resource "aws_vpc" "argo_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "argo_vpc"
  }
}

# Subnet info
resource "aws_subnet" "argo_subnet" {
  cidr_block = "10.1.1.0/24"
  vpc_id     = aws_vpc.argo_vpc.id
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "argo_subnet"
  }
}

# Internet Gateway info
resource "aws_internet_gateway" "argo_igw" {
  vpc_id = aws_vpc.argo_vpc.id

  tags = {
    Name = "argo_igw"
  }
}

# Create route tables
resource "aws_route_table" "argo_pub_rt" {
  vpc_id = aws_vpc.argo_vpc.id

  tags = {
    Name = "argo_pub_rt"
  }
}

# Associate public route table with internet gateway
resource "aws_route" "argo_route" {
  route_table_id = aws_route_table.argo_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.argo_igw.id
}

# Associate route tables with subnets
resource "aws_route_table_association" "argo_rta" {
  subnet_id      = aws_subnet.argo_subnet.id
  route_table_id = aws_route_table.argo_pub_rt.id
}
