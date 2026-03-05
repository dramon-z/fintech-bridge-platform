
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  name = "payments-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

resource "aws_security_group" "alb_sg" {
  name   = "payments-alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "payments-ecs-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb" "payments_alb" {
  name               = "payments-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets

  security_groups = [aws_security_group.alb_sg.id]
}
resource "aws_lb_target_group" "payments_tg" {
  name     = "payments-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path = "/docs"
  }
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.payments_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.payments_tg.arn
  }
}

resource "aws_ecs_cluster" "payments" {
  name = "payments-cluster"
}

resource "aws_ecs_task_definition" "payments" {
  family                   = "payments-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "payments-api"
      image = "ECR_REGISTRY_URL/payments-api:latest"

      portMappings = [
        {
          containerPort = 8000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "payments" {
  name            = "payments-service"
  cluster         = aws_ecs_cluster.payments.id
  task_definition = aws_ecs_task_definition.payments.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.payments_tg.arn
    container_name   = "payments-api"
    container_port   = 8000
  }
}

#Logging (SOC2 + Observability)
resource "aws_cloudwatch_log_group" "payments" {
  name = "/ecs/payments-api"
}

resource "aws_ssm_parameter" "vendor_api_key" {
  name  = "/payments/vendor/api_key"
  type  = "SecureString"
  value = "mock-api-key"
}
