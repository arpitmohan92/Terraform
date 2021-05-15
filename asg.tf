resource "aws_autoscaling_group" "Prod-asg" {
  name = "Prod-asg"
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.prod_template.id
    version = "$Latest"
     tag {
    key                 = "Name"
    value               = "Prod-App"
    propagate_at_launch = true
    }
  }
  
  health_check_type = "ELB"
  
  target_group_arns = "aws_lb_target_group.Prod-Tg.arn"
  
  vpc_zone_identifier = ["aws_subnet.AppServerSub1.id", "aws_subnet.AppServerSub2.id"]

resource "aws_autoscaling_notification" "prod_notifications" {
  group_names = [aws_autoscaling_group.Prod-asg.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  
  topic_arn = aws_sns_topic.prod_sns.arn
}

resource "aws_sns_topic" "prod_sns" {
  name = "example-topic"
}

resource "aws_autoscaling_policy" "example" {
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}
 
