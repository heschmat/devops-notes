
output "ec2_public_ip" {
  description = "public ip address of the ec2 instance"
  value       = aws_instance.server1.public_ip
}


output "vpc_id" {
  value = aws_vpc.main.id

}

output "ami_id" {
  value = aws_instance.server1.ami
}
