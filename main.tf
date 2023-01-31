provider "aws" {
  version = "~>3.0"
  region = "us-east-1"
}
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "Terraform"
  }
}
resource "aws_subnet" "sub" {
  vpc_id = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.0.128/25"
  tags = {
    Name = "terraform"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
  tags   = {
    Name = "igwterraform"
  }
}
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = rt1
  }
}
resource "aws_route_table_association" "rtassociation" {
  route_table_id = aws_route_table.rt1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_security_group" "sgterraform" {
  name = "ec2sg"
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "ins" {
  ami = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.id
  subnet_id = aws_subnet.sub.id
  security_groups = [aws_security_group.sgterraform.id]

}
resource "aws_key_pair" "key" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6DjbVVOm3JugMXVwT6yYIuHaPdNJTz486BBM6P3gpmlQ2/rfonp0pUFrRA0TmuVR5zNQOGoSJdQcT5Qtt2Gn15OQP4EwpaHoZLw5WoJ7RHlQzJ21jjMd2+djOHjWBsIKffc2LDTjUIoZVFyD4X1mELrTUw1/w5/U7UUFnjic9M9kWGxSMLSFFuPzsZLgUMPh8yVzZpiYAmfFj8LAPRYWPf4az5S/2J1seJpYRtfF/W/GtTWC+tbrqBYOjZWXys9mtsoHna9EyifU6iPJZAWAyw44lMAPVphIlCqUOxiLKIyMonlsIpnYrcwSxS3oDygBzk2rUbikofp8Q8B82RYsLQVg1qUaUH0cQDq88CW6us5b/qp19E7XBkZfjX+hfrqzPOy3tDBDOfJwzv98JsWIno/mmv5NFqV1+uV8SWlD35ajUOQ+/9I9u/RmTdJIalEJl2XjV+Zpy41Bfqys1hyXEVxFOoEeM+jf/MoZyETLeBrFYxpEWRyLRB9P0KEc1H/M= ansaniya santhosh@LAPTOP-NM1MTHVS"
}