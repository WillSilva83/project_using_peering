## Projeto de Arquitetura - Utilizando Peering 


A ideia desse projeto é testar uma atividade feita em aula de Network. 

A parte provavelmente mais dificil foi "traduzir" a atividade em um desenho de arquitetura. 

A parte boa é que o ChatGPT falou que está bom, então vamos seguir com ela até entender algo mais simples.

Desculpa se o README parecer um diário, pois será mesmo. 


Vamos ao que importa! 

A ideia ainda é meio simploria teremos duas VPCs e elas vão conversar uma com a outra :)

Mas colocando um pouco de complexidade, teremos uma comunicação entre redes diferentes sendo auxiliada por duas Routers Tables. Confia, vai dar bom. 

# TO DOs 
- Deixar as subnets em uma AZ mesma AZ quando fizerem parte do mesmo tipo (pública ou privada)

## A divisão de Pastas - Não menos importante 

Estou testando meios de configuração de pastas, mas ainda não cheguei em uma definitiva. 
Ao meu ver os modulos ficam mais organizados em pastas <i>services<i/>


Veja como faço minha distribuição: 

```shell
.
├── images
│   └── image.png
├── main.tf
├── README.md
└── services
    ├── instance
    │   └── main.tf
    └── network
        ├── main.tf
        └── output.tf

4 directories, 6 files
```

Ainda estou entendendo como funciona a parte de modularização, então tempo ao tempo. 

To-Do! 

- Entender melhor como organizar o código no output.tf (preciso dar sentido pra isso depois, por isso o to-do)

![alt text](./images/diagram_network.png)


## Diagrama do Terraform 

Veja que lindezas o Terraform pode extrair. 


``` 
digraph G {
  rankdir = "RL";
  node [shape = rect, fontname = "sans-serif"];
  subgraph "cluster_module.instace.module.network" {
    label = "module.instace.module.network"
    fontname = "sans-serif"
    "module.instace.module.network.aws_internet_gateway.igw_a" [label="aws_internet_gateway.igw_a"];
    "module.instace.module.network.aws_internet_gateway.igw_b" [label="aws_internet_gateway.igw_b"];
    "module.instace.module.network.aws_route.a_route_igw" [label="aws_route.a_route_igw"];
    "module.instace.module.network.aws_route.b_route_igw" [label="aws_route.b_route_igw"];
    "module.instace.module.network.aws_route.route_vpc_a_to_vpc_b" [label="aws_route.route_vpc_a_to_vpc_b"];
    "module.instace.module.network.aws_route.route_vpc_b_to_vpc_b" [label="aws_route.route_vpc_b_to_vpc_b"];
    "module.instace.module.network.aws_route_table.a_rtb-private" [label="aws_route_table.a_rtb-private"];
    "module.instace.module.network.aws_route_table.a_rtb-public" [label="aws_route_table.a_rtb-public"];
    "module.instace.module.network.aws_route_table.b_rtb_private" [label="aws_route_table.b_rtb_private"];
    "module.instace.module.network.aws_route_table.b_rtb_public" [label="aws_route_table.b_rtb_public"];
    "module.instace.module.network.aws_route_table_association.a_rtb_private_assoc" [label="aws_route_table_association.a_rtb_private_assoc"];
    "module.instace.module.network.aws_route_table_association.a_rtb_public_assoc" [label="aws_route_table_association.a_rtb_public_assoc"];
    "module.instace.module.network.aws_route_table_association.b_rtb_private_assoc" [label="aws_route_table_association.b_rtb_private_assoc"];
    "module.instace.module.network.aws_route_table_association.b_rtb_public_assoc" [label="aws_route_table_association.b_rtb_public_assoc"];
    "module.instace.module.network.aws_subnet.private_subnet_a_1" [label="aws_subnet.private_subnet_a_1"];
    "module.instace.module.network.aws_subnet.private_subnet_a_2" [label="aws_subnet.private_subnet_a_2"];
    "module.instace.module.network.aws_subnet.private_subnet_b_1" [label="aws_subnet.private_subnet_b_1"];
    "module.instace.module.network.aws_subnet.private_subnet_b_2" [label="aws_subnet.private_subnet_b_2"];
    "module.instace.module.network.aws_subnet.public_subnet_a_1" [label="aws_subnet.public_subnet_a_1"];
    "module.instace.module.network.aws_subnet.public_subnet_a_2" [label="aws_subnet.public_subnet_a_2"];
    "module.instace.module.network.aws_subnet.public_subnet_b_1" [label="aws_subnet.public_subnet_b_1"];
    "module.instace.module.network.aws_subnet.public_subnet_b_2" [label="aws_subnet.public_subnet_b_2"];
    "module.instace.module.network.aws_vpc.vpc_a" [label="aws_vpc.vpc_a"];
    "module.instace.module.network.aws_vpc.vpc_b" [label="aws_vpc.vpc_b"];
    "module.instace.module.network.aws_vpc_endpoint.vpc_a_s3_endpoint" [label="aws_vpc_endpoint.vpc_a_s3_endpoint"];
    "module.instace.module.network.aws_vpc_endpoint.vpc_b_s3_endpoint" [label="aws_vpc_endpoint.vpc_b_s3_endpoint"];
    "module.instace.module.network.aws_vpc_peering_connection.peer_vpc_a_to_vpc_b" [label="aws_vpc_peering_connection.peer_vpc_a_to_vpc_b"];
  }
  "module.instace.module.network.aws_internet_gateway.igw_a" -> "module.instace.module.network.aws_vpc.vpc_a";
  "module.instace.module.network.aws_internet_gateway.igw_b" -> "module.instace.module.network.aws_vpc.vpc_b";
  "module.instace.module.network.aws_route.a_route_igw" -> "module.instace.module.network.aws_internet_gateway.igw_a";
  "module.instace.module.network.aws_route.a_route_igw" -> "module.instace.module.network.aws_route_table.a_rtb-public";
  "module.instace.module.network.aws_route.b_route_igw" -> "module.instace.module.network.aws_internet_gateway.igw_b";
  "module.instace.module.network.aws_route.b_route_igw" -> "module.instace.module.network.aws_route_table.b_rtb_public";
  "module.instace.module.network.aws_route.route_vpc_a_to_vpc_b" -> "module.instace.module.network.aws_route_table.a_rtb-private";
  "module.instace.module.network.aws_route.route_vpc_a_to_vpc_b" -> "module.instace.module.network.aws_vpc_peering_connection.peer_vpc_a_to_vpc_b";
  "module.instace.module.network.aws_route.route_vpc_b_to_vpc_b" -> "module.instace.module.network.aws_route_table.b_rtb_private";
  "module.instace.module.network.aws_route.route_vpc_b_to_vpc_b" -> "module.instace.module.network.aws_vpc_peering_connection.peer_vpc_a_to_vpc_b";
  "module.instace.module.network.aws_route_table.a_rtb-private" -> "module.instace.module.network.aws_vpc.vpc_a";
  "module.instace.module.network.aws_route_table.a_rtb-public" -> "module.instace.module.network.aws_vpc.vpc_a";
  "module.instace.module.network.aws_route_table.b_rtb_private" -> "module.instace.module.network.aws_vpc.vpc_b";
  "module.instace.module.network.aws_route_table.b_rtb_public" -> "module.instace.module.network.aws_vpc.vpc_b";
  "module.instace.module.network.aws_route_table_association.a_rtb_private_assoc" -> "module.instace.module.network.aws_route_table.a_rtb-private";
  "module.instace.module.network.aws_route_table_association.a_rtb_private_assoc" -> "module.instace.module.network.aws_subnet.private_subnet_a_1";
  "module.instace.module.network.aws_route_table_association.a_rtb_private_assoc" -> "module.instace.module.network.aws_subnet.private_subnet_a_2";
  "module.instace.module.network.aws_route_table_association.a_rtb_public_assoc" -> "module.instace.module.network.aws_route_table.a_rtb-public";
  "module.instace.module.network.aws_route_table_association.a_rtb_public_assoc" -> "module.instace.module.network.aws_subnet.public_subnet_a_1";
  "module.instace.module.network.aws_route_table_association.a_rtb_public_assoc" -> "module.instace.module.network.aws_subnet.public_subnet_a_2";
  "module.instace.module.network.aws_route_table_association.b_rtb_private_assoc" -> "module.instace.module.network.aws_route_table.b_rtb_private";
  "module.instace.module.network.aws_route_table_association.b_rtb_private_assoc" -> "module.instace.module.network.aws_subnet.private_subnet_b_1";
  "module.instace.module.network.aws_route_table_association.b_rtb_private_assoc" -> "module.instace.module.network.aws_subnet.private_subnet_b_2";
  "module.instace.module.network.aws_route_table_association.b_rtb_public_assoc" -> "module.instace.module.network.aws_route_table.b_rtb_public";
  "module.instace.module.network.aws_route_table_association.b_rtb_public_assoc" -> "module.instace.module.network.aws_subnet.public_subnet_b_1";
  "module.instace.module.network.aws_route_table_association.b_rtb_public_assoc" -> "module.instace.module.network.aws_subnet.public_subnet_b_2";
  "module.instace.module.network.aws_subnet.private_subnet_a_1" -> "module.instace.module.network.aws_vpc.vpc_a";
  "module.instace.module.network.aws_subnet.private_subnet_a_2" -> "module.instace.module.network.aws_vpc.vpc_a";
  "module.instace.module.network.aws_subnet.private_subnet_b_1" -> "module.instace.module.network.aws_vpc.vpc_b";
  "module.instace.module.network.aws_subnet.private_subnet_b_2" -> "module.instace.module.network.aws_vpc.vpc_b";
  "module.instace.module.network.aws_subnet.public_subnet_a_1" -> "module.instace.module.network.aws_vpc.vpc_a";
  "module.instace.module.network.aws_subnet.public_subnet_a_2" -> "module.instace.module.network.aws_vpc.vpc_a";
  "module.instace.module.network.aws_subnet.public_subnet_b_1" -> "module.instace.module.network.aws_vpc.vpc_b";
  "module.instace.module.network.aws_subnet.public_subnet_b_2" -> "module.instace.module.network.aws_vpc.vpc_b";
  "module.instace.module.network.aws_vpc_endpoint.vpc_a_s3_endpoint" -> "module.instace.module.network.aws_route_table.a_rtb-private";
  "module.instace.module.network.aws_vpc_endpoint.vpc_b_s3_endpoint" -> "module.instace.module.network.aws_route_table.b_rtb_private";
  "module.instace.module.network.aws_vpc_peering_connection.peer_vpc_a_to_vpc_b" -> "module.instace.module.network.aws_vpc.vpc_a";
  "module.instace.module.network.aws_vpc_peering_connection.peer_vpc_a_to_vpc_b" -> "module.instace.module.network.aws_vpc.vpc_b";
}
```



Vou inserir depois com o terraform graph mesmo achando feio pra cacete


## Coisas Importantes que foram aprendidas 

### LOOPING!!! - Faremos uma parte 2 depois rs 

Sério, isso aqui é tão bom quanto - ta ligado, né?

Agora vamos deixar explicito algumas coisas 

DEU TUDO ERRADO AAAAAAAA 
Mas acontece que realmente a complexidade saiu de 1 para escala de 20 (pensando em números que nem fazem sentido)
Então por enquanto vamos deixar os loopings de lado e começar a terminar o projeto 


```hcl
# variables.tf

variable "vpc_cidr_blocks_list" {
  type = map(object({    # Informando qual a composicao do objeto
    prefix_vpc = string
    cidr_block = string
  }))
  ## O que faz parte do objeto 
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

``` 

```hcl

resource "aws_vpc" "VPCs" {
  for_each = var.vpc_cidr_blocks_list
  
  cidr_block = each.value.cidr_block

  tags = {
    Name = "VPC-${each.value.prefix_vpc}"
  }
}

## IGW -
resource "aws_internet_gateway" "igw" {
  
  for_each = aws_vpc.VPCs
  vpc_id = each.value.id
  tags = {
    Name = "IGW-${each.value.tags["Name"]}"
  }
}

```

## Alguns passos depois... 

Chegamos em um ponto em que é possível se ver nessa arquitetura de rede, temos algo simples, porém funcional. 

Utilizando-se da melhor forma de looping que o terraform e o chatgpt podem oferecer. 

Agora o grande passo é: 

## Como vou criar a mesma estrutura de Rede com apenas mudanças de parametros? 

Essa é a grande questão para quem está começando e criando uma arquitetura relativamente (pequena) grande. Problema esse agora que pode ser feito da mesma forma que foi resolvidos os outros. 

Aqui só não podemos nos acostumar com lixeira, por favor. Queremos um código limpo e funcional. 

![alt text](./images/image.png)

Imagem do pequeno sucesso. 



## Como referenciar?


## 