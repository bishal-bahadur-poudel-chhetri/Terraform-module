

resource "aws_lb_target_group" "target-a" {
  name     = var.lgname
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "tg_attachment-a" {
  count              = var.environment == "Production" ? 2 : 1
  target_group_arn   = aws_lb_target_group.target-a.arn
  target_id          = element(var.private_servers, count.index) # Ensure var.private_servers is a list
  port               = 80
}



resource "aws_lb" "aws_network_lb" {
  name                   = var.aws_lb_name
  internal               = false
  load_balancer_type     = var.lb_type 
  security_groups        = var.lb_type == "network" ? [var.security_group] : [] 
  subnets                = var.subnets
  enable_deletion_protection = false
  tags = {
    Environment = var.environment
  }
}

#alb rule
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.aws_network_lb.arn
  port              = 80
  protocol          = "HTTP" # or "TCP" for NLB
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-a.arn
  }
}

resource "aws_lb_listener_rule" "rule_b" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 60
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-a.arn
  }
  condition {
    path_pattern {
      values = ["/images*"]
    }
  }
}
