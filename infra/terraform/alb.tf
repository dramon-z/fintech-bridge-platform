resource "aws_lb" "payments_alb" {
  name               = "payments-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
}