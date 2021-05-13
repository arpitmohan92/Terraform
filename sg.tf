resource "aws_security_group" "allow_traffic" {
  name        = "WebLbSg"
  description = "Allow 80 inbound traffic"
  vpc_id      = aws_vpc.Prod-vpc.id

  ingress {
    description = "Web traffic from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebLbSg"
  }
}

resource "aws_security_group" "allow_traffic_from_lb" {
  name        = "AppServerSg"
  description = "Allow traffic from Load Balancer"
  vpc_id      = aws_vpc.Prod-vpc.id

  ingress {
    description     = "Allow traffic from Load Balancer"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_traffic.id]
  }

  ingress {
    description     = "Allow traffic from Load Balancer"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_traffic.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "AppServerSg"
  }
}

resource "aws_security_group" "allow_traffic_from_App" {
  name        = "DatabaseSg"
  description = "Allow traffic from app server"
  vpc_id      = aws_vpc.Prod-vpc.id

  ingress {
    description     = "Traffic from App server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_traffic_from_lb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DatabaseSg"
  }
}
