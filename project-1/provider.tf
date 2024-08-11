terraform {
  cloud {
    organization = "Abingwas-Foundation"

    workspaces {
      name = "Abingwa_CLI_Flow"
    }
  }
   required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-west-1"
  alias = "N-California"
}