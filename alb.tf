resource "aws_lb" "Prod-Lb" {
  name               = "Prod-Lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_traffic.id]
  subnets            = [aws_subnet.AppLbSub1.id, aws_subnet.AppLbSub2.id]

  enable_deletion_protection = false

  tags = {
    Environment = "Prod-Lb"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.Prod-Lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Prod-Tg.arn
  }
}

resource "aws_lb_target_group" "Prod-Tg" {
  name     = "Prod-Tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.Prod-vpc.id
}
