variable "cidr_block_vpc_a" {
  description = "Valor do cidr_block."
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_block_vpc_b" {
  description = "Valor do cidr_block."
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpc_cidr_blocks_list" {
  type = map(object({
    prefix_vpc = string
    cidr_block = string
  }))

  default = {
    "vpc_a" = {
      prefix_vpc = "A"
      cidr_block = "10.0.0.0/16"
    }
    "vpc_b" = {
      prefix_vpc = "B"
      cidr_block = "10.1.0.0/16"
    }
  }
}

variable "A_subnets_public_vpc_a" {
  type = map(object({
    cidr_block = string
    type       = string
  }))

  default = {
    "A_public_subnet1a" = {
      cidr_block = "10.0.1.0/24"
      type       = "public"
    }

    "A_public_subnet1b" = {
      cidr_block = "10.0.2.0/24"
      type       = "public"
    }
  }
}

variable "A_subnets_private_vpc_a" {
  type = map(object({
    cidr_block = string
    type       = string
  }))

  default = {
    "A_private_subnet1a" = {
      cidr_block = "10.0.3.0/24"
      type       = "private"
    }

    "A_private_subnet1b" = {
      cidr_block = "10.0.4.0/24"
      type       = "private"
    }
  }
}
