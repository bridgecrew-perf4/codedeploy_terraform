# Create a VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.220.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "lab_one" {
  vpc_id     = aws_vpc.lab_vpc.id
  cidr_block = "10.220.1.0/24"
  map_public_ip_on_launch= true
  tags = {
    Name = "One"
  }
  availability_zone = data.aws_availability_zones.available.names[0]
  }


resource "aws_subnet" "lab_two" {
  vpc_id     = aws_vpc.lab_vpc.id
  cidr_block = "10.220.2.0/24"
  map_public_ip_on_launch= true

  tags = {
    Name = "Two"
  }
  availability_zone = data.aws_availability_zones.available.names[1]
  }

resource "aws_security_group" "allow_http" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.lab_vpc.id

}
resource "aws_route_table" "r" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}
resource "aws_route_table_association" "rone" {
  subnet_id      = aws_subnet.lab_one.id
  route_table_id = aws_route_table.r.id
}
resource "aws_route_table_association" "rtwo" {
  subnet_id      = aws_subnet.lab_two.id
  route_table_id = aws_route_table.r.id
}