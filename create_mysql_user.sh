#!/bin/bash

# Prompt for MySQL root authentication
echo "Enter MySQL root username:"
read ROOT_USER

echo "Enter MySQL root password:"
read -s ROOT_PASSWORD

# Test MySQL root authentication
echo "Testing MySQL root login..."
mysql -u"$ROOT_USER" -p"$ROOT_PASSWORD" -e "SELECT VERSION();" &> /dev/null

if [ $? -ne 0 ]; then
    echo "❌ Authentication failed. Please check your root username and password."
    exit 1
fi

echo "✅ Authentication successful."

# Prompt for new MySQL username and password
echo "Enter the new MySQL username to create:"
read NEW_USER

echo "Enter password for new MySQL user '$NEW_USER':"
read -s NEW_PASSWORD

# Create new user and grant all privileges from any host
echo "Creating MySQL user '$NEW_USER' with full privileges..."
mysql -u"$ROOT_USER" -p"$ROOT_PASSWORD" <<EOF
CREATE USER '$NEW_USER'@'%' IDENTIFIED BY '$NEW_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$NEW_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo "✅ MySQL user '$NEW_USER' created successfully with all privileges."
else
    echo "❌ Failed to create MySQL user. Please check your inputs."
fi


