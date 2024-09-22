
#########
#  VPC  #
#########

resource "aws_vpc" "vpc_a" {
  cidr_block = var.cidr_block_vpc_a
  tags = {
    Name = "VPC-A"
  }
}

resource "aws_vpc" "vpc_b" {
  cidr_block = var.cidr_block_vpc_b
  tags = {
    Name = "VPC-B"
  }
}

## PEERING 
resource "aws_vpc_peering_connection" "peer_vpc_a_to_vpc_b" {
  vpc_id      = aws_vpc.vpc_a.id # Solicitante
  peer_vpc_id = aws_vpc.vpc_b.id # Receptor

  auto_accept = true # Aceitar automaticamente o peering

  tags = {
    Name = "VPC-Peering-A-to-B"
  }

}



## IGW -
resource "aws_internet_gateway" "igw_a" {

  vpc_id = aws_vpc.vpc_a.id
  tags = {
    Name = "IGW-A"
  }
}

resource "aws_internet_gateway" "igw_b" {
  vpc_id = aws_vpc.vpc_b.id
  tags = {
    Name = "IGW-B"
  }

}




## ROUTER TABLES VPC A 
resource "aws_route_table" "a_rtb-private" {
  vpc_id = aws_vpc.vpc_a.id

  tags = {
    Name = "VPC-A-rtb-private"
  }
}

resource "aws_route_table" "a_rtb-public" {
  vpc_id = aws_vpc.vpc_a.id

  tags = {
    Name = "VPC-A-rtb-public"
  }
}
## ROUTER TABLES VPC B
resource "aws_route_table" "b_rtb_private" {
  vpc_id = aws_vpc.vpc_b.id

  tags = {
    Name = "VPC-B-rtb-private"
  }
}
resource "aws_route_table" "b_rtb_public" {
  vpc_id = aws_vpc.vpc_b.id

  tags = {
    Name = "VPC-B-rtb-public"
  }
}

##  ROUTE 
# ROTA A 
resource "aws_route" "route_vpc_a_to_vpc_b" {
  route_table_id            = aws_route_table.a_rtb-private.id
  destination_cidr_block    = aws_vpc.vpc_b.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_vpc_a_to_vpc_b.id
}
# ROTA B 
resource "aws_route" "route_vpc_b_to_vpc_b" {
  route_table_id            = aws_route_table.b_rtb_private.id
  destination_cidr_block    = aws_vpc.vpc_a.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_vpc_a_to_vpc_b.id

}


## ENDPOINT S3
resource "aws_vpc_endpoint" "vpc_a_s3_endpoint" {
  vpc_id          = aws_vpc.vpc_a.id
  service_name    = "com.amazonaws.sa-east-1.s3"
  route_table_ids = [aws_route_table.a_rtb-private.id]

  tags = {
    Name = "VPC-A-S3-Endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc_b_s3_endpoint" {
  vpc_id          = aws_vpc.vpc_b.id
  service_name    = "com.amazonaws.sa-east-1.s3"
  route_table_ids = [aws_route_table.b_rtb_private.id]

}


## VPC A - ROUTE TABLE ASSOCIATION FOR SUBNETS
resource "aws_route_table_association" "a_rtb_private_assoc" {
  for_each = {
    "private_subnet_a_1" = aws_subnet.private_subnet_a_1.id
    "private_subnet_a_2" = aws_subnet.private_subnet_a_2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.a_rtb-private.id

}

resource "aws_route_table_association" "a_rtb_public_assoc" {
  for_each = {
    "public_subnet_a_1" = aws_subnet.public_subnet_a_1.id
    "public_subnet_a_2" = aws_subnet.public_subnet_a_2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.a_rtb-public.id
}


## VPC - B ROUTE TABLE ASSOCIATION FOR SUBNETS

resource "aws_route_table_association" "b_rtb_private_assoc" {
  for_each = {
    "private_subnet_b_1" = aws_subnet.private_subnet_b_1.id
    "private_subnet_b_2" = aws_subnet.private_subnet_b_2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.b_rtb_private.id
}

resource "aws_route_table_association" "b_rtb_public_assoc" {
  for_each = {
    "public_subnet_b_1" = aws_subnet.public_subnet_b_1.id
    "public_subnet_b_2" = aws_subnet.public_subnet_b_2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.b_rtb_public.id
}

## ROUTE FOR IGW

resource "aws_route" "a_route_igw" {
  route_table_id         = aws_route_table.a_rtb-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_a.id

}

resource "aws_route" "b_route_igw" {
  route_table_id         = aws_route_table.b_rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_b.id
}



output "vpc_a" {
  value = aws_vpc.vpc_a.id

}

output "vpc_b" {
  value = aws_vpc.vpc_b.id
  
}

output "subnet_private_a" {
  value = aws_subnet.private_subnet_a_1.id
  
}

output "subnet_private_b" {
  value = aws_subnet.private_subnet_b_1.id
  
}

output "subnet_public_a" {
  value = aws_subnet.public_subnet_a_1.id
  
}