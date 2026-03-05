
output "api_url" {
  value = aws_lb.payments_alb.dns_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "cluster_arn" {
  value = aws_ecs_cluster.payments.arn
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.payments.arn
}

output "service_arn" {
  value = aws_ecs_service.payments.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.payments.name
}
output "log_group_arn" {
  value = aws_cloudwatch_log_group.payments.arn
}

output "vendor_api_key" {
  value = aws_ssm_parameter.vendor_api_key.value
  sensitive = true
}   