
#########
#  VPC  #
#########

resource "aws_vpc" "VPC_A" {
    cidr_block = var.cidr_block_vpc_a
    
    tags = {
      Name = "VPC-A"
    }
}

## SUBNET 

resource "aws_subnet" "VPC_A_subnet_public_a" {
    vpc_id = aws_vpc.VPC_A.id
    cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "name" {
  
}