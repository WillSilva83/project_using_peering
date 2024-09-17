variable "cidr_block_vpc_a" {
    description = "Valor do cidr_block."
    type = string
    default = "10.0.0.0/16"
}

## Veremos como melhorar isso depois 

variable "subnets_public_vpc_a" {
    type =  map(string)
    default = {
      "subnet1a" = "10.0.1.0/24"
      "subnet1b" = "10.0.2.0/24"
    }
}

variable "subnets_private_vpc_b" {
    type =  map(string)
    default = {
      "subnet1a" = "10.0.3.0/24"
      "subnet1b" = "10.0.4.0/24"
    }
}