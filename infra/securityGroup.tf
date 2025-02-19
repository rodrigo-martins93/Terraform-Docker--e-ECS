resource "aws_security_group" "alb" {
    name        = "alb_ecs"
    description = "Allow traffic application load balancer"
    vpc_id      = module.vpc.vpc_id

    tags = {
        Name = "alb_ecs"
    }
}

resource "aws_security_group_rule" "alb_ingress" {
    type              = "ingress"
    from_port         = 8000
    to_port           = 8000
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "allow_all" {
    type              = "egress"
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    from_port         = 0
    security_group_id = aws_security_group.alb.id
    }

resource "aws_security_group" "private_sg" {
    name        = "private_ecs"
    description = "Private security group"
    vpc_id      = module.vpc.vpc_id

    tags = {
        Name = "private_sg"
    }
}

resource "aws_security_group_rule" "private_ingress_ecs" {
    type              = "ingress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    source_security_group_id = aws_security_group.alb.id
    security_group_id = aws_security_group.private_sg.id
}

resource "aws_security_group_rule" "private_egress_ecs" {
    type              = "egress"
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    from_port         = 0
    security_group_id = aws_security_group.private_sg.id
    }
