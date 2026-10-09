
output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.pep_ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.pep_ec2.public_dns
}