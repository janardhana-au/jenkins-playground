#!/bin/bash
growpart /dev/nvme0n1 4
lvextend -L +20G /dev/mapper/RootVG-homeVol
lvextend -L +10G /dev/mapper/RootVG-varVol 
xfs_growfs /home
xfs_growfs /var
dnf upgrade -y 
# Add required dependencies for the jenkins package
dnf install fontconfig java-21-openjdk -y

# Terraform Installation
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

# NodeJs installation
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
yum install zip -y

# docker
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh