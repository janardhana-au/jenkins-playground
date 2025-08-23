#!/bin/bash

growpart /dev/nvme0n1 4
lvextend -L +15G /dev/mapper/RootVG/rootVol
lvextend -L +15G /dev/mapper/RootVG/varVol
xfs_growfs /
xfs_growfs /var

curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf upgrade -y 
# Add required dependencies for the jenkins package
dnf install fontconfig java-21-openjdk -y
dnf install jenkins -y 
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins