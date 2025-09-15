# Public instance with nginx
resource "aws_instance" "public_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_default_security_group.default_sg.id]
  # associate_public_ip_address = true
  key_name  = aws_key_pair.example.key_name
  user_data = file("${path.root}/user-data.sh")

  tags = {
    Name = "public server"
  }
}

# Private instance
resource "aws_instance" "private_server" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_default_security_group.default_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.example.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd polkit
              systemctl enable httpd
              systemctl start httpd
              echo "Alohaaaaaaaaa from TF via httpd" > /var/www/html/index.html
              EOF

  tags = {
    Name = "server2-private"
  }
}
