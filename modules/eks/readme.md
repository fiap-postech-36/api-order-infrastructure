# EKS Infraestrutura Terraform

Este repositório fornece a infraestrutura básica para criar cluster na AWS EKS usando o Terraform. O módulo pode ser facilmente integrado ao seu projeto Terraform para provisionar um cluster com as configurações necessárias.

## Como usar o módulo

Para utilizar este módulo em seu projeto Terraform, siga os passos abaixo:

### Passo 1: Configuração do Provider

Primeiro, você precisa configurar o provider AWS no seu projeto Terraform. Adicione a configuração do provider no arquivo Terraform (por exemplo, `main.tf`):

```hcl
provider "aws" { 
  region = "us-east-1"  # Substitua pela região desejada, por exemplo, "us-west-2"
}

provider "kubernetes" {
  host                   = module.eks.endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

```

### Passo 2: Chamada do Módulo

Em seguida, chame o módulo para criar a VPC e as sub-redes. Adicione a seguinte configuração ao seu arquivo Terraform:

```hcl
module "vpc" {
  source = "github.com/fiap-postech-36/eks-infrastructure?ref=v1.0.0"  # Chama o módulo VPC do repositório

  cluster_name                = "my-cluster"                # Nome do cluster
  vpc_id            = "vpc-id-value"
  default_region = ["us-east-1"] # Região padrão previamente definida no provider  

  security_group_id = "sg-id-value" # ID do security group
}
```


### Explicação dos Parâmetros

#### `cluster_name` (obrigatório)
- **Descrição**: Nome do cluster EKS
- **Exemplo**: `"my-cluster"`

#### `vpc_id` (obrigatório)
- **Descrição**: ID da VPC existente que será utilizada para o cluster EKS.
- **Exemplo**: `""vpc-id-value""`

#### `default_region` (obrigatório)
- **Descrição**: Região padrão em que o cluster EKS e a VPC serão criados. A região deve ser fornecida em um formato de lista de strings, contendo a região principal (ex.: ["us-east-1"]).
- **Exemplo**: `["us-east-1"]`

#### `security_group_id` (obrigatório)
- **Descrição**: ID do security group (grupo de segurança) a ser associado à VPC e ao cluster EKS. Este security group gerenciará as permissões de tráfego de rede para os recursos dentro do cluster.
- **Exemplo**: `"sg-id-value"`

---

## Considerações

- Certifique-se de ajustar os valores do EKS de acordo com as necessidades do seu projeto.
- O módulo cria apenas os recursos básicos do EKS (Cluster e Node Module). Outros recursos, como instâncias K8s e etc., precisam ser configurados separadamente.