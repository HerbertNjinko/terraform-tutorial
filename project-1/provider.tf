terraform {
  cloud {
    organization = "Abingwas-Foundation"

    workspaces {
      name = "Abingwa_CLI_Flow"
    }
  }
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = ">= 1.0.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}