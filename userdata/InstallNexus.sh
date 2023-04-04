#!/bin/bash

# Install Java
#apt-get install default-jre -y
#apt install default-jdk -y
useradd ec2-user

# Update the packages
apt-get update -y

# Download Nexus
cd /opt/
wget https://download.sonatype.com/nexus/3/nexus-3.47.1-01-unix.tar.gz

# Unzip/Untar the compressed file
tar -xf nexus-3.47.1-01-unix.tar.gz && rm -rf *.tar.gz

# Rename folder for ease of use
mv nexus-3.* nexus3

# Enable permission for ec2-user to work on nexus3 and sonytype-work folers
chown -R ec2-user:ec2-user nexus3/ sonatype-work/

apt-get install openjdk-8-jdk -y

# Create a file called nexus.rc and add run as ec2-user
cd /opt/nexus3/bin/
touch nexus.rc
echo 'run_as_user="ec2-user"' > /opt/nexus3/bin/nexus.rc
echo -e "INSTALL4J_JAVA_HOME_OVERRIDE=/usr/lib/jvm/java-8-openjdk-amd64" >> /opt/nexus3/bin/nexus

# Add nexus as a service at boot time
ln -s /opt/nexus3/bin/nexus /etc/init.d/nexus
# cd /etc/init.d
# chkconfig --add nexus
# chkconfig --levels 345 nexus on

# Start Nexus
systemctl start nexus