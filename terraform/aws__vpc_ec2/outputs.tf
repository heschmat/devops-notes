output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_public_ip" {
  value       = aws_instance.public_server.public_ip
  description = "Public IP of the Bastion host"
}
