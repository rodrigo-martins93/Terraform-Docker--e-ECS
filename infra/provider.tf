terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = ">= 4.66.1"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region  = "us-west-2"
}