
resource "aws_subnet" "public_subnet_a_1" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "VPC-A-Subnet-1"
  }
}

resource "aws_subnet" "public_subnet_a_2" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "VPC-A-Subnet-1"
  }
}

resource "aws_subnet" "private_subnet_a_1" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "VPC-A-Subnet-1"
  }
}

resource "aws_subnet" "private_subnet_a_2" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "VPC-A-Subnet-1"
  }
}



resource "aws_subnet" "public_subnet_b_1" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "VPC-B-Subnet-1"
  }
}

resource "aws_subnet" "public_subnet_b_2" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "VPC-B-Subnet-1"
  }
}

resource "aws_subnet" "private_subnet_b_1" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.1.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "VPC-B-Subnet-1"
  }
}

resource "aws_subnet" "private_subnet_b_2" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.1.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "VPC-B-Subnet-1"
  }
}