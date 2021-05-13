resource "aws_launch_template" "prod_template" {
  name = "Prod-template"
  description = "Production template for asg"
  
  block_device_mappings {
    device_name = "/dev/sda1"
    
    ebs {
      volume_size = 8
      delete_on_termination = true
      volume_type = "gp2"
    }
  }
  
  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }
  
  credit_specification {
    cpu_credits = "standard"
  }
  
  disable_api_termination = true

  ebs_optimized = true
    
  iam_instance_profile {
    arn = "arn:aws:iam::301424319303:instance-profile/S3FullAccess"
  }
  
  image_id = "ami-077e31c4939f6a2f3"
    
  instance_initiated_shutdown_behavior = "terminate"
    
  instance_market_options {
    market_type = "spot"
  }
  
  network_interfaces {
    delete_on_termination = true
    security_groups = aws_security_group.allow_traffic_from_lb.id
    subnet_id = "aws_subnet.AppServerSub1.id"
  } 
  
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Prod-App"
    }
  }  
}    
    
    
