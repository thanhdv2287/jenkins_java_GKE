#!/bin/bash

# Ensure that your software packages are up to date on your instance by uing the following command to perform a quick software update:


# Add the Jenkins repo using the following command:

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

# Import a key file from Jenkins-CI to enable installation from the package:
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

apt-get update -y

# Install Java:
apt-get install default-jdk -y

# Install Git:
apt-get install git -y

# Install Jenkins:
apt-get install jenkins -y

# Enable the Jenkins service to start at boot:


# Start Jenkins as a service:
systemctl start jenkins

# Reference: https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/