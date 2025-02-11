#!/bin/bash

DOCKER_CONFIG="/etc/docker/daemon.json"

# Prompt user for the new IP range
read -p "Enter the Docker network IP range (e.g., 11.0.0.0/16): " NETWORK_CIDR

# Extract base IP
BASE_IP=$(echo $NETWORK_CIDR | cut -d'/' -f1 | awk -F'.' '{print $1"."$2"."$3".1"}')

echo "Configuring Docker to use $NETWORK_CIDR network..."

# Ensure Docker configuration directory exists
mkdir -p /etc/docker

# Backup existing Docker config
if [ -f "$DOCKER_CONFIG" ]; then
    cp "$DOCKER_CONFIG" "$DOCKER_CONFIG.bak"
fi

# Write new configuration
cat <<EOF > "$DOCKER_CONFIG"
{
    "bip": "$BASE_IP/$(echo $NETWORK_CIDR | cut -d'/' -f2)",
    "default-address-pools": [
        {
            "base": "$(echo $NETWORK_CIDR | cut -d'/' -f1)/8",
            "size": 24
        }
    ]
}
EOF

echo "Restarting Docker service..."
systemctl restart docker

echo "Verifying Docker network settings..."
docker network inspect bridge | grep Subnet

echo "Docker is now using the $NETWORK_CIDR network."

