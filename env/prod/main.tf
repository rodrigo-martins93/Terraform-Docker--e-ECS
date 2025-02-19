module "prod" {
    source = "../../infra"
    
    ecr_repository_name = "prod-repository"
    roleIAM = "prod"
    environment = "prod"
}

output "ip_alb" {
    value = module.prod.ip
}