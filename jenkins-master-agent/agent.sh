#!/bin/bash
growpart /dev/nvme0n1 4
lvextend -L +20G /dev/mapper/RootVG-homeVol
lvextend -L +10G /dev/mapper/RootVG-varVol 
xfs_growfs /home
xfs_growfs /var
dnf upgrade -y 
# Add required dependencies for the jenkins package
dnf install fontconfig java-21-openjdk -y

