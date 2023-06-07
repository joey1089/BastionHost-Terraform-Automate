output "ec2_remote_access" {
  description = "EC2 Remote Access"
  value       = "ssh -i ${local_file.private_key_pem.filename} ec2-user@${aws_instance.BastionHost-Uec2I.public_ip}"
}

output "instance_public_ip" {
  description = "Public IP address of the Jenkins EC2 instance"
  value       = "Jenkins Server Public IP: ${aws_instance.BastionHost-Uec2I.public_ip}"
}