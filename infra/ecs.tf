module "ecs" {
    source = "terraform-aws-modules/ecs/aws"

    cluster_name = var.environment

    cluster_configuration = {
        execute_command_configuration = {
        logging = "OVERRIDE"
        log_configuration = {
            cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
        }
        }
    }

    fargate_capacity_providers = {
        FARGATE = {
        default_capacity_provider_strategy = {
            weight = 100
        }
        }
    }
}

resource "aws_ecs_task_definition" "django_api" {
    family                   = "django-api"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = 256
    memory                   = 512
    execution_role_arn       = aws_iam_role.roleIAM.arn
    container_definitions    = jsonencode(
    [
    {
        "name"= "prod-repository"
        "image"= "533267381091.dkr.ecr.us-west-2.amazonaws.com/prod-repository:v1"
        "cpu"= 256
        "memory"= 512
        "essential"= true
        "portMappings": [
            {
                "containerPort"= 8000
                "hostPort"= 8000
            }
    ]
    }
    ]
    )
}

resource "aws_ecs_service" "django_api" {
    name            = "django-api"
    cluster         = module.ecs.cluster_id
    task_definition = aws_ecs_task_definition.django_api.arn
    desired_count   = 3

    load_balancer {
        target_group_arn = aws_lb_target_group.target-group.arn
        container_name   = "prod-repository"
        container_port   = 8000
    }

    network_configuration{
        subnets          = module.vpc.private_subnets
        security_groups  = [aws_security_group.alb.id]
    }

    capacity_provider_strategy {
        capacity_provider = "FARGATE"
        weight            = 1
    }
}