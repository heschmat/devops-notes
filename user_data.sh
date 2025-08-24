#!/bin/bash
set -euo pipefail

# Redirect full logs
exec > >(tee -a /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

# after installation check the logs to verify:
# sudo less /var/log/user-data.log
# for quick summary:
# cat /var/log/install-summary.log
# --------------------------------------------------


echo "===== Starting user-data script at $(date) ====="

apt-get update -y
apt-get upgrade -y
apt-get install -y ca-certificates curl gnupg lsb-release unzip

# --------------------------------------------------
# Docker
# --------------------------------------------------
echo ">>> Installing Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# --------------------------------------------------
# kubectl
# --------------------------------------------------
echo ">>> Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# --------------------------------------------------
# eksctl
# --------------------------------------------------
echo ">>> Installing eksctl..."
curl -sSL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" -o eksctl.tar.gz
tar -xzf eksctl.tar.gz -C /tmp
mv /tmp/eksctl /usr/local/bin/
rm -f eksctl.tar.gz

# --------------------------------------------------
# Helm
# --------------------------------------------------
echo ">>> Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# --------------------------------------------------
# Terraform
# --------------------------------------------------
echo ">>> Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

ARCH=$(dpkg --print-architecture)
CODENAME=$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs)

echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $CODENAME main" \
  > /etc/apt/sources.list.d/hashicorp.list

apt-get update -y
apt-get install -y terraform

# --------------------------------------------------
# Jenkins
# --------------------------------------------------
echo ">>> Installing Jenkins..."
apt-get install -y openjdk-17-jre

curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key \
  -o /usr/share/keyrings/jenkins-keyring.asc

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -y
apt-get install -y jenkins

systemctl enable jenkins
systemctl start jenkins

usermod -aG docker jenkins
systemctl restart jenkins

# --------------------------------------------------
# AWS CLI
# --------------------------------------------------
echo ">>> Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# --------------------------------------------------
# Health check summary
# --------------------------------------------------
echo "===== Installation Summary ($(date)) =====" > /var/log/install-summary.log

{
  echo ""
  echo "--- Docker ---"
  docker --version || echo "Docker FAILED"
  systemctl is-active --quiet docker && echo "Docker service: running" || echo "Docker service: NOT running"

  echo ""
  echo "--- kubectl ---"
  kubectl version --client || echo "kubectl FAILED"

  echo ""
  echo "--- eksctl ---"
  eksctl version || echo "eksctl FAILED"

  echo ""
  echo "--- Helm ---"
  helm version --short || echo "Helm FAILED"

  echo ""
  echo "--- Terraform ---"
  terraform version | head -n 1 || echo "Terraform FAILED"

  echo ""
  echo "--- Jenkins ---"
  systemctl is-active --quiet jenkins && echo "Jenkins service: running" || echo "Jenkins service: NOT running"

  echo ""
  echo "--- AWS CLI ---"
  aws --version || echo "AWS CLI FAILED"

} >> /var/log/install-summary.log 2>&1

echo "===== User-data script completed at $(date) ====="
