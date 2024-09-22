## Importando o modulo de Rede aqui apenas

module "network" {
    source = "../network"
}

## SECURITY GROUP VPC A 
resource "aws_security_group" "vpc_a_sg" {
  name = "SG-A"
  description = "Security Group da VPC A"
  vpc_id = module.network.vpc_a             ## OUTPUT 


    ingress {
        description = "Permite SSH"
        from_port = 22 
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = [ "10.1.0.0/16" ] # CIDR VPC B 
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        security_groups = [aws_security_group.vpc_a_sg_public.id]

    }

    egress {
        from_port =  0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["10.1.0.0/16"] # CIDR VPC B
    }

    tags = {
      Name = "VPC-A-SECURITY-GROUP"
    }

}

resource "aws_security_group" "vpc_b_sg" {
    name = "SG-B"
    description = "Security Group da VPC B"
    vpc_id = module.network.vpc_b

    ingress  {
        description = "Permite SSH"
        from_port = 22 
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"] # CIDR VPC A 
    }

    egress {
        from_port = 0 
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["10.0.0.0/16"] # CIR VPC A 
    }

    tags = {
      Name = "VPC-B-SECURITY-GROUP"
    }
  
}

resource "aws_security_group" "vpc_a_sg_public" {
    name = "SG-A-Public"
    description = "Security Group VPC A - Publico"
    vpc_id = module.network.vpc_a

    ingress {
        from_port = 22
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

# INSTACIAS 
resource "aws_instance" "vpc_a_instance_a" {
    ami = "ami-0cd690123f92f5079"
    instance_type = "t2.micro"
    subnet_id = module.network.subnet_private_a

    vpc_security_group_ids = [aws_security_group.vpc_a_sg.id]

    key_name = "project_vpcs"

    tags = {
      Name = "VPC-A-Instance-A"
    }
}

resource "aws_instance" "vpc_b_instance_a" {
    ami = "ami-0cd690123f92f5079"
    instance_type = "t2.micro"
    subnet_id = module.network.subnet_private_b
    vpc_security_group_ids = [aws_security_group.vpc_b_sg.id]

    tags = {
      Name = "VPC-B-Instance-B"
    }
}

resource "aws_instance" "instance_public" {
    ami = "ami-0cd690123f92f5079"
    instance_type = "t2.micro"
    subnet_id = module.network.subnet_public_a

    key_name = "project_vpcs"

    vpc_security_group_ids = [aws_security_group.vpc_a_sg_public.id]

    tags = {
      Name = "VPC-A-Instance-A-Public"
    }
  
}