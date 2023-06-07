# ------------------- root/main.tf --------------------------

#Create VPC and its subnets
# Custom VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_tag
  }
}

# Public Subnet for bastion host
resource "aws_subnet" "subnet_public_bastion" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr_bhec2
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_public_bastionhost"
  }

}

# Private Subnet
resource "aws_subnet" "subnet_private" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr_pec2
  availability_zone = "us-east-1b"

  tags = {
    Name = var.subnet_tag
  }
}


# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.internet_gateway_tag
  }
}

# Route Table
resource "aws_default_route_table" "default_route" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

# Public IP and add to Security Group
data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

# Security Group
resource "aws_security_group" "bastion-host-sg" {
  name_prefix = var.security_group_name
  description = "Bastion Host instance security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH from my Public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #replace with your system ip
  }

  ingress {
    description = "Allows HTTP Access to the Bastion Host"
    from_port   = 8080
    to_port     = 8080
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
    Name = "bastion-host-sg"
  }
}

resource "aws_security_group" "private_sg" {
  name_prefix = var.security_group_name
  description = "Bastion Host instance security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH from my Public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion-host-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "private-sg"
  }
}

# Create SSH Keys for EC2 Remote Access
resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.generated.private_key_pem
  filename        = "${var.ssh_key_name}.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "generated" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.generated.public_key_openssh
}

# EC2 Instance - BastionHost -Ubuntu, 22.04 LTS
resource "aws_instance" "BastionHost-Uec2I" {
  ami             = "ami-053b0d53c279acc90"  #ami-053b0d53c279acc90 #t3.micro also can use free tier t2.micro
  instance_type   = "t2.micro"
  key_name        = var.ssh_key_name
  security_groups = [aws_security_group.bastion-host-sg.id]
  subnet_id       = aws_subnet.subnet_public_bastion.id
  
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    throughput            = 500
    delete_on_termination = true
  }
}

# EC2 Instance - Ubuntu -Ubuntu, 22.04 LTS
resource "aws_instance" "ubuntu-instance" {
  ami             = "ami-053b0d53c279acc90"  #ami-053b0d53c279acc90 #t3.micro
  instance_type   = "t2.micro"
  key_name        = var.ssh_key_name
  security_groups = [aws_security_group.bastion-host-sg.id]
  subnet_id = aws_subnet.subnet_private.id


  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    throughput            = 300
    delete_on_termination = true
  }
}