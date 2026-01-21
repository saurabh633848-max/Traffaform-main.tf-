provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "public_vpc" {
  cidr_block = "17.0.0.0/18"

  tags = {
    Name = "Public VPC"
  }
}

# Internet Gateway (needed for public VPC)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.public_vpc.id

  tags = {
    Name = "Public-IGW"
  }
}

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.public_vpc.id
  cidr_block              = "17.0.0.0/18"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.public_vpc.id

  # Internet access route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-03f4878755434977f"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "MyFirstEC2"
  }
}
