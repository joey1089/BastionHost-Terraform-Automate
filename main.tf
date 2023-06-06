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
  instance_type   = "t3.micro"
  key_name        = var.ssh_key_name
  security_groups = [aws_security_group.jenkins_security_group.id]
  subnet_id       = aws_subnet.subnet_public_ubuntu.id
  user_data       = data.template_file.user_data.rendered

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
  instance_type   = "t3.small"
  key_name        = var.ssh_key_name
  security_groups = [aws_security_group.jenkins_security_group.id]
  subnet_id       = aws_subnet.subnet_public_ubuntu.id
  user_data       = data.template_file.user_data.rendered

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    throughput            = 300
    delete_on_termination = true
  }
}