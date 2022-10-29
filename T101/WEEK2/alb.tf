resource "aws_lb" "imok_alb" {
  name               = "${var.tags[0]}-imok-alb"
  load_balancer_type = "application"
  subnets            = [element(aws_subnet.imok_pub_sub.*.id, 0), element(aws_subnet.imok_pub_sub.*.id, 1)]
  security_groups    = [aws_security_group.imok_alb_sg.id]

  tags = {
    Name = "${var.tags[0]}-imok-alb"
  }
}

resource "aws_lb_listener" "imok_http" {
  load_balancer_arn = aws_lb.imok_alb.arn
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

resource "aws_lb_listener" "imok_https" {
  load_balancer_arn = aws_lb.imok_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.imok_acm_certi

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "imok_albtg" {
  name     = "${var.tags[0]}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.imok_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "imok_albrule" {
  listener_arn = aws_lb_listener.imok_https.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.imok_albtg.arn
  }
}
