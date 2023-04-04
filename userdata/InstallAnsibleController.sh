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

# Update the installed packages and package cache
apt-get update -y

# Install the ansible
#apt-get install epel -y
apt-get install ansible -y