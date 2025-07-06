provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "xops_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "xops_subnet" {
  vpc_id                  = aws_vpc.xops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "xops_igw" {
  vpc_id = aws_vpc.xops_vpc.id
}

resource "aws_route_table" "xops_route_table" {
  vpc_id = aws_vpc.xops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.xops_igw.id
  }
}

resource "aws_route_table_association" "xops_rta" {
  subnet_id      = aws_subnet.xops_subnet.id
  route_table_id = aws_route_table.xops_route_table.id
}

resource "aws_security_group" "xops_sg" {
  name   = "xops-sg"
  vpc_id = aws_vpc.xops_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "xops_ec2" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.xops_subnet.id
  vpc_security_group_ids = [aws_security_group.xops_sg.id]
  key_name      = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<html><body><h1>Hi this is Ajith from XOps!</h1></body></html>" > /var/www/html/index.html
              rm -f /etc/httpd/conf.d/welcome.conf
              systemctl restart httpd
              EOF

}
