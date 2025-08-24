# Generate an SSH key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload the public key to AWS
resource "aws_key_pair" "example" {
  key_name   = "server-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Save the private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.root}/server1-key.pem"
  file_permission = "0400"
}
