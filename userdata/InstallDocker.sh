#!/bin/bash

# Add user ansible admin
useradd ansibleadmin 
useradd ec2-user

# Set password: the below command will avoid re-entering the password
echo -e "ansibleadmin\nansibleadmin" | passwd ansibleadmin

# Modify the sudoers file at /etc/sudoers and add entry
echo 'ansibleadmin  ALL=(ALL)   NOPASSWD: ALL' | tee -a /etc/sudoers
echo 'ec2-user ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers

# Enable Password Authentication
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd


# Install the most recent Docker Engine package
sudo apt-get update -y
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg -y

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the installed packages and package cache
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


# Start the Docker service
systemctl start docker

# Auto start Docker service after booting


# Install docker module for Python2 (require for ansible)
apt-get install python3-pip -y
pip install docker-py -y

# Add user ansible admin to docker group (execute without using sudo)
usermod -a -G docker ansibleadmin