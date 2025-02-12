#!/bin/bash

# Update package list and install necessary dependencies
sudo apt update -y
sudo apt install -y wget lsb-release gnupg

# Add MySQL APT repository
wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.29-1_all.deb

# Update package list after adding the repository
sudo apt update -y

# Install the latest MySQL server
sudo apt install -y mysql-server

# Start and enable MySQL service
sudo systemctl enable mysql
sudo systemctl start mysql

# Prompt user for MySQL root password
echo "Enter the MySQL root password:"
read -s ROOT_PASSWORD

# Secure MySQL installation
echo "Running MySQL secure installation..."

mysql_secure_installation <<EOF
$ROOT_PASSWORD
n
y
y
y
y
EOF

echo "MySQL installation and secure setup completed successfully."

