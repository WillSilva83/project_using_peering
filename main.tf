provider "aws" {

    region = var.aws_region
  
}

module "instace" {
    source = "./services/instance"
  
}