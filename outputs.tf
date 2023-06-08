output "remote_access_key" {
  description = "EC2 Remote Access"
  value       = "ssh -i ${local_file.private_key_pem.filename} ubuntu@${aws_instance.BastionHost-Uec2I.public_ip}"
}

output "instance_public_ip" {
  description = "Public IP address of the Jenkins EC2 instance"
  value       = "Bastion Host Public IP: ${aws_instance.BastionHost-Uec2I.public_ip}"
}