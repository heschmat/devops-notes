# This is declarative metadata that tells Terraform which provider plugins to use,
# where to get them from, and which versions are allowed.
terraform {
  # NOTE: It's possible to have more than 1 argument in the `required_providers` block.
  required_providers {
    aws = {
      # Use the aws provider from the hashicorp namespace.
      source = "hashicorp/aws"
      # Allow versions compatible with 5.x (e.g., 5.1, 5.12, but not 6.0).
      version = "~> 5.0"
    }
  }
}

# Use the AWS provider (as defined in required_providers)
# and configure it to operate in the specified region ...
provider "aws" {
  region = "us-east-1"
}

# General syntax for `resource` block:
# resource "<provider>_<resource_type>" "local_name" {}
# N.B. blocks could required no (terraform, required_providers), one (provider) or two labels (resources).
# A block contains arguments (key/pair) and other nested blocks.

# create VPC ----------------------
# this also creates other required resources, such as: route table & NACL
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.main_vpc_name} VPC"
  }
}

resource "aws_subnet" "web" {
  vpc_id = aws_vpc.main.id

  cidr_block        = var.web_subnet
  availability_zone = var.subnet_zone

  tags = {
    "Name" = "Web subnet"
  }
}

resource "aws_internet_gateway" "web" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.main_vpc_name} IGW"
  }
}

resource "aws_default_route_table" "web" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web.id
  }

  tags = {
    "Name" = "default-rt"
  }
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = [var.my_public_ip] # hts cidr_block issue?
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Default SG"
  }
}


/*
Make sure to run these two commands before `terraform apply`

ssh-keygen -t rsa -b 2048 -C 'test key' -N '' -f !/.ssh/test_rsa
chmod 400 ~/.ssh/test_rsa
*/
resource "aws_key_pair" "test_ssh_key" {
  key_name = "testing_ssh_key"
  # file() returns the content of the file passed as string.
  public_key = file(var.ssh_public_key)
}
# N.B. As the public key belongs to the instance,
# changing the public key file a new instance will be created.


data "aws_ami" "latest_amazon_linux2" {
  owners = ["amazon"]
  # if more than one is returned, pick the most recent one
  most_recent = true

  # List of available filters:
  # # https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
  filter {
    name   = "name"
    values = ["amzn2-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

#/*
resource "aws_instance" "server1" {
  ami           = data.aws_ami.latest_amazon_linux2.id
  instance_type = "t3.nano"

  subnet_id = aws_subnet.web.id

  vpc_security_group_ids = [aws_default_security_group.default_sg.id]

  associate_public_ip_address = true
  #key_name                    = "server_ssh_key" # in ~/.ssh directory
  key_name = aws_key_pair.test_ssh_key.key_name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # Enforces IMDSv2
  }

  tags = {
    "Name" : "My Server - Amazon Linux 2"
  }

}

#*/
