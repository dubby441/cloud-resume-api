terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" { 
  region = "us-east-1"  # Change to your preferred region
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
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
}

resource "aws_instance" "cloud_resume" {
  ami                    = "ami-084568db4383264d4"  # Amazon Linux 2
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main_subnet.id
  security_groups        = [aws_security_group.web_sg.id]
#   associate_public_ip_address = true

  key_name = var.key_name
 user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y docker.io git
              systemctl start docker
              usermod -aG docker ubuntu
              EOF

tags = {
    Name = "cloud-resume"
  }
}

resource "aws_eip" "eip" {
  vpc = true

   lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.cloud_resume.id
  allocation_id = aws_eip.eip.id
}

# resource "null_resource" "provisioner" {
#   depends_on = [aws_eip_association.eip_assoc]

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update",
#       "sudo apt install -y docker.io git",
#       "sudo service docker start",
#       "sudo usermod -aG docker ubuntu",
#       "docker --version"
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file(var.private_key_path)
#       host        = aws_eip.eip.public_ip
#       timeout     = "2m"
#     }
#   }

#   triggers = {
#     instance_id = aws_instance.cloud_resume.id
#   }
# }
