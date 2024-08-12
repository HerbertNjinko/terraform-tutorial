terraform {
  cloud {
    organization = "Abingwas-Foundation"

    workspaces {
      name = "Hyper-V_setup"
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
  region = "us-west-1"
}
