resource "aws_vpc" "Prod-vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "prod-env"
  }
}

resource "aws_subnet" "AppLbSub1" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "AppLbSub1"
  }
}

resource "aws_subnet" "AppLbSub2" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "AppLbSub2"
  }
}

resource "aws_subnet" "AppServerSub1" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "192.168.3.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "AppServerSub1"
  }
}

resource "aws_subnet" "AppServerSub2" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "192.168.4.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "AppServerSub2"
  }
}

resource "aws_subnet" "DatabaseSub1" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "192.168.5.0/24"

  tags = {
    Name = "DatabaseSub1"
  }
}

resource "aws_subnet" "DatabaseSub2" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "192.168.6.0/24"

  tags = {
    Name = "DatabaseSub2"
  }
}

resource "aws_subnet" "NatSub" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "192.168.7.0/24"

  tags = {
    Name = "NatSub"
  }
}

resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.Prod-vpc.id

  tags = {
    Name = "Prod-igw"
  }
}

resource "aws_route_table" "Public-Route" {
  vpc_id     = aws_vpc.Prod-vpc.id
  depends_on = [aws_internet_gateway.Prod-igw]

  tags = {
    Name = "Public-Route"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Prod-igw.id
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "Prod-ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.NatSub.id

  tags = {
    Name = "Prod-ngw"
  }
}

resource "aws_route_table" "Private-Route" {
  vpc_id     = aws_vpc.Prod-vpc.id
  depends_on = [aws_nat_gateway.Prod-ngw]

  tags = {
    Name = "Private-Route"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Prod-ngw.id
  }
}

resource "aws_route_table_association" "PublicRouteAssociate1" {
  subnet_id = aws_subnet.AppLbSub1.id

  route_table_id = aws_route_table.Public-Route.id
}

resource "aws_route_table_association" "PublicRouteAssociate2" {
  subnet_id = aws_subnet.AppLbSub2.id

  route_table_id = aws_route_table.Public-Route.id
}

resource "aws_route_table_association" "PublicRouteAssociate3" {
  subnet_id = aws_subnet.NatSub.id

  route_table_id = aws_route_table.Public-Route.id
}

resource "aws_route_table_association" "PrivateRouteAssociate1" {
  subnet_id = aws_subnet.AppServerSub1.id

  route_table_id = aws_route_table.Private-Route.id
}

resource "aws_route_table_association" "PrivateRouteAssociate2" {
  subnet_id = aws_subnet.AppServerSub2.id

  route_table_id = aws_route_table.Private-Route.id
}

resource "aws_route_table_association" "PrivateRouteAssociate3" {
  subnet_id = aws_subnet.DatabaseSub1.id

  route_table_id = aws_route_table.Private-Route.id
}

resource "aws_route_table_association" "PrivateRouteAssociate4" {
  subnet_id = aws_subnet.DatabaseSub2.id

  route_table_id = aws_route_table.Private-Route.id
}
