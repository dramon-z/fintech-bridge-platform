
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "payments-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "aws_lb" "payments_alb" {
  name               = "payments-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
}

resource "aws_ecs_cluster" "payments" {
  name = "payments-cluster"
}