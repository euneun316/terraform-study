## ALB
# service_alb
resource "aws_lb" "service_alb" {
  count              = length(var.env)
  name               = "${var.tags}-${var.env[count.index]}-alb-service"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.service_alb_sg.id]
  subnets            = [element(aws_subnet.pub_sub.*.id, 0), element(aws_subnet.pub_sub.*.id, 1)]

  tags = {
    Name = "${var.tags}-${var.env[count.index]}-alb-service"
  }
}

# management_alb
resource "aws_lb" "management_alb" {
  count              = length(var.env)
  name               = "${var.tags}-${var.env[count.index]}-alb-management"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.management_alb_sg.id]
  subnets            = [element(aws_subnet.pub_sub.*.id, 0), element(aws_subnet.pub_sub.*.id, 1)]

  tags = {
    Name = "${var.tags}-${var.env[count.index]}-alb-management"
  }
}

## ALB target group & attachment
# dev service_tg
resource "aws_lb_target_group" "dev_service_tg" {
  count    = length(var.service_server_port)
  name     = "${var.tags}-${var.env[0]}-service-tg-${var.service_server_port[count.index]}"
  port     = var.service_server_port[count.index]
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

# dev service_tg_attach_2a
resource "aws_alb_target_group_attachment" "dev_service_tg_attach_2a" {
  count            = length(aws_lb_target_group.dev_service_tg)
  target_group_arn = element(aws_lb_target_group.dev_service_tg.*.arn, count.index)
  target_id        = aws_instance.dev_service_2a.id
  port             = var.service_server_port[count.index]
}

# prd service_tg
resource "aws_lb_target_group" "prd_service_tg" {
  count    = length(var.service_server_port)
  name     = "${var.tags}-${var.env[1]}-service-tg-${var.service_server_port[count.index]}"
  port     = var.service_server_port[count.index]
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

# prd service_tg_attach_2a
resource "aws_alb_target_group_attachment" "prd_service_tg_attach_2a" {
  count            = length(aws_lb_target_group.prd_service_tg)
  target_group_arn = element(aws_lb_target_group.prd_service_tg.*.arn, count.index)
  target_id        = aws_instance.prd_service_2a.id
  port             = var.service_server_port[count.index]
}

# prd service_tg_attach_2c
resource "aws_alb_target_group_attachment" "prd_service_tg_attach_2c" {
  count            = length(aws_lb_target_group.prd_service_tg)
  target_group_arn = element(aws_lb_target_group.prd_service_tg.*.arn, count.index)
  target_id        = aws_instance.prd_service_2c.id
  port             = var.service_server_port[count.index]
}

# dev management_tg
resource "aws_lb_target_group" "dev_management_tg" {
  count    = length(var.management_server_port)
  name     = "${var.tags}-${var.env[0]}-management-tg-${var.management_server_port[count.index]}"
  port     = var.management_server_port[count.index]
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

# dev management_tg_attach_2a
resource "aws_alb_target_group_attachment" "dev_management_tg_attach_2a" {
  count            = length(aws_lb_target_group.dev_management_tg)
  target_group_arn = element(aws_lb_target_group.dev_management_tg.*.arn, count.index)
  target_id        = aws_instance.dev_management_2a.id
  port             = var.management_server_port[count.index]
}

# prd management_tg
resource "aws_lb_target_group" "prd_management_tg" {
  count    = length(var.management_server_port)
  name     = "${var.tags}-${var.env[1]}-management-tg-${var.management_server_port[count.index]}"
  port     = var.management_server_port[count.index]
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

# prd management_tg_attach_2a
resource "aws_alb_target_group_attachment" "prd_management_tg_attach_2a" {
  count            = length(aws_lb_target_group.prd_management_tg)
  target_group_arn = element(aws_lb_target_group.prd_management_tg.*.arn, count.index)
  target_id        = aws_instance.prd_management_2a.id
  port             = var.management_server_port[count.index]
}

## ALB listener Redirect Action
# service alb listener_http
resource "aws_lb_listener" "service_alb_listener_http" {
  count             = length(var.env)
  load_balancer_arn = element(aws_lb.service_alb.*.arn, count.index)
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# service alb listener_https
resource "aws_lb_listener" "service_alb_listener_https" {
  count             = length(var.env)
  load_balancer_arn = element(aws_lb.service_alb.*.arn, count.index)
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certi

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "503"
    }
  }
}

# management alb listener_http
resource "aws_lb_listener" "management_alb_listener_http" {
  count             = length(var.env)
  load_balancer_arn = element(aws_lb.management_alb.*.arn, count.index)
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# dev management alb listener_https
resource "aws_lb_listener" "dev_management_alb_listener_https" {
  count             = length(var.management_server_port)
  load_balancer_arn = element(aws_lb.management_alb.*.arn, 0)
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certi

  default_action {
    type             = "forward"
    target_group_arn = element(aws_lb_target_group.dev_management_tg.*.arn, count.index)
  }
}

# prd management alb listener_https
resource "aws_lb_listener" "prd_management_alb_listener_https" {
  count             = length(var.management_server_port)
  load_balancer_arn = element(aws_lb.management_alb.*.arn, 1)
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certi

  default_action {
    type             = "forward"
    target_group_arn = element(aws_lb_target_group.prd_management_tg.*.arn, count.index)
  }
}
