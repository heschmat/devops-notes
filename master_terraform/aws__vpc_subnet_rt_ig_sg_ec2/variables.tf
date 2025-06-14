variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
  type        = string
}

variable "web_subnet" {
  default     = "10.0.0.0/24"
  description = "CIDR for Web Subnet"
  type        = string
}

variable "subnet_zone" {

}

variable "main_vpc_name" {}

variable "my_public_ip" {}

variable "ssh_public_key" {}

