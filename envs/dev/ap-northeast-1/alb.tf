# ALB Module
module "alb" {
  source = "../../../modules/aws-alb"

  project_name              = var.project_name
  vpc_id                    = data.aws_vpc.main.id
  subnet_ids                = [data.aws_subnet.public_01.id, data.aws_subnet.public_02.id]
  security_group_ids        = [module.security_groups.alb_security_group_id]
  internal                  = false
  enable_deletion_protection = false
  target_port               = var.app_port
  target_protocol           = "HTTP"
  certificate_arn           = module.acm.certificate_arn
  enable_https              = true
  enable_http_redirect      = true
  tags                      = local.common_tags

  health_check = {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}
