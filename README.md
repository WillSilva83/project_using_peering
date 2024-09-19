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
- Replicar uma VPC sem a necessidade de copiar e colar o código 
- Adicionar o Peering entre VPC A e VPC B (entende-se como sucesso o final disso.)

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

![alt text](./images/image.png)


## Diagrama do Terraform 

Veja que lindezas o Terraform pode extrair. 


Vou inserir depois com o terraform graph mesmo achando feio pra cacete


## Coisas Importantes que foram aprendidas 

### LOOPING!!!

Sério, isso aqui é tão bom quanto - ta ligado, né? Mas 

```hcl
variable "subnets" {
  type = map(string)
  default = {
    "subnet1" = "10.0.1.0/24"
    "subnet2" = "10.0.2.0/24"
    "subnet3" = "10.0.3.0/24"
  }
}

resource "aws_subnet" "my_subnet" {
  for_each = var.subnets

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value

  tags = {
    Name = each.key
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

![alt text](image.png)

Imagem do pequeno sucesso. 



## Como referenciar?


## 