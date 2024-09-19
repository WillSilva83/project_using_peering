
#########
#  VPC  #
#########

resource "aws_vpc" "VPC_A" {
  cidr_block = var.cidr_block_vpc_a

  tags = {
    Name = "VPC-A"
  }
}



## IGW -
resource "aws_internet_gateway" "igw-vpc-a" {
  vpc_id = aws_vpc.VPC_A.id
  tags = {
    Name = "IGW-VPC-A"
  }
}


## SUBNETS

resource "aws_subnet" "subnets_vpc_a" {
  for_each = merge(var.A_subnets_public_vpc_a, var.A_subnets_private_vpc_a)

  vpc_id     = aws_vpc.VPC_A.id
  cidr_block = each.value.cidr_block

  tags = {
    Name = each.key
    Type = each.value.type
  }
}


## ROUTER TABLES 
resource "aws_route_table" "A_rtb-private" {
  vpc_id = aws_vpc.VPC_A.id

  tags = {
    Name = "A-rtb-private"
  }

}

resource "aws_route_table" "A_rtb-public" {
  vpc_id = aws_vpc.VPC_A.id

  tags = {
    Name = "A-rtb-public"
  }

}

## ENDPOINT S3
resource "aws_vpc_endpoint" "A_S3_endpoint" {
  vpc_id          = aws_vpc.VPC_A.id
  service_name    = "com.amazonaws.sa-east-1.s3"  # Verifique se a região está correta
  route_table_ids = [aws_route_table.A_rtb-private.id]

  tags = {
    Name = "VPC-A-S3-Endpoint"
  }
}



## ROUTE TABLE ASSOCIATION FOR PRIVATE SUBNET 

resource "aws_route_table_association" "A_rtb_private_assoc" {
  for_each       = { for key, value in var.A_subnets_private_vpc_a : key => value if value.type == "private" }
  subnet_id      = aws_subnet.subnets_vpc_a[each.key].id
  route_table_id = aws_route_table.A_rtb-private.id
}

resource "aws_route_table_association" "A_rtb_public_assoc" {
  for_each       = { for key, value in var.A_subnets_public_vpc_a : key => value if value.type == "public" }
  subnet_id      = aws_subnet.subnets_vpc_a[each.key].id
  route_table_id = aws_route_table.A_rtb-public.id
}

## ROUTE FOR IGW
resource "aws_route" "A_route_igw" {
  route_table_id         = aws_route_table.A_rtb-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-vpc-a.id 

}

