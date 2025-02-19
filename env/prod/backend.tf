terraform {
    backend "s3" {
        bucket = "terraform-state-rodrigo"
        key    = "prod/terraform.tfstate"
        region = "us-west-2"
    }
}