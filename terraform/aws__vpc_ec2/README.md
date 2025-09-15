# Terraform AWS VPC + EC2 Infrastructure

This project provisions a basic AWS infrastructure using **Terraform**. It creates a VPC, subnets, NAT/Internet gateways, route tables, security groups, and EC2 instances (public and private). It also demonstrates SSH key management, user data provisioning, and outputs.

---

## 📂 Project Structure

```
.
├── provider.tf         # Provider configuration (AWS, TLS, Local)
├── variables.tf        # Input variables with defaults
├── terraform.tfvars    # Variable overrides
├── data.tf             # Data sources (fetch latest Amazon Linux 2 AMI)
├── outputs.tf          # Outputs (VPC ID, EC2 public IP)
├── networking.tf       # VPC, Subnets, Gateways, Route Tables
├── security.tf         # Security Group (Ingress & Egress rules)
├── keypair.tf          # SSH key pair (TLS + AWS + local file)
├── compute.tf          # EC2 instances (public + private)
├── user-data.sh        # User data script for public instance (Nginx)
```

---

## ⚙️ Concepts Covered

### 1. Providers & Terraform Setup

* Uses **AWS** provider (`hashicorp/aws`) to manage infrastructure.
* Uses **TLS** provider (`hashicorp/tls`) to generate SSH keys.
* Uses **Local** provider (`hashicorp/local`) to save files locally.

### 2. Variables & Configuration

* `variables.tf` defines:

  * AWS region (`us-east-1`)
  * Availability zones
  * VPC CIDR block
  * Subnet CIDR blocks
  * EC2 instance type
* `terraform.tfvars` overrides defaults for subnets and VPC.

### 3. Networking Layer

* Creates a **VPC** with CIDR block `10.0.0.0/16`.
* Creates **Public** and **Private subnets**.
* Attaches an **Internet Gateway** for public subnet.
* Provisions a **NAT Gateway** (with Elastic IP) for private subnet internet access.
* Configures **Route Tables**:

  * Public route table → routes traffic to Internet Gateway.
  * Private route table → routes traffic to NAT Gateway.

### 4. Security

* Default VPC security group is customized.
* Allows inbound traffic on ports **22 (SSH)**, **80 (HTTP)**, and **8080 (custom Nginx)**.
* Allows outbound traffic to anywhere (`0.0.0.0/0`).

### 5. Key Pair Management

* Generates a new **SSH key pair** using `tls_private_key`.
* Uploads the **public key** to AWS via `aws_key_pair`.
* Stores the **private key** locally via `local_file` (`server1-key.pem`).

### 6. Compute Layer

* **Public EC2 instance**:

  * Uses latest Amazon Linux 2 AMI.
  * Provisioned with **Nginx** on port `8080` via `user-data.sh`.
* **Private EC2 instance**:

  * Uses Apache HTTPD as a web server.
  * No public IP; accessible only via NAT and Bastion host.

### 7. Outputs

* **VPC ID** for reference.
* **Public IP** of the Bastion (public EC2 instance).

---

## 🚀 How to Use

```bash
# Initialize providers & modules
terraform init

# Review planned changes
terraform plan

# Apply infrastructure
terraform apply -auto-approve

# Destroy resources when done
terraform destroy -auto-approve

```

Here's how you can access the apps:
```sh
# for public instance

curl -v <instance_public_ip>:8080

# for the private instance
# first ssh into the public instance

ssh -i server1-key.pem ec2-user@<instance_publi_ip>
# ii: now inside the publi instance terminal

curl -v <private_ip_private_instance>:80
```
