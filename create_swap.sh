#!/bin/bash

SWAP_FILE="/swapfile"

# Check if swap is already enabled
if sudo swapon --show | grep -q "$SWAP_FILE"; then
    echo "Swap is already enabled at $SWAP_FILE."
    read -p "Do you want to modify the swap size? (y/n): " MODIFY_SWAP
    if [[ "$MODIFY_SWAP" != "y" ]]; then
        echo "No changes made. Exiting..."
        exit 0
    fi

    # Disable and remove existing swap
    echo "Disabling and removing existing swap..."
    sudo swapoff $SWAP_FILE
    sudo rm -f $SWAP_FILE
fi

# Prompt for new swap size
read -p "Enter swap size (e.g., 2G, 4G, 8G): " SWAP_SIZE

if [[ -z "$SWAP_SIZE" ]]; then
    echo "No swap size entered. Exiting..."
    exit 1
fi

echo "Creating a $SWAP_SIZE swap file at $SWAP_FILE..."

# Create the swap file
sudo fallocate -l $SWAP_SIZE $SWAP_FILE

# Set the correct permissions
sudo chmod 600 $SWAP_FILE

# Format the file as swap space
sudo mkswap $SWAP_FILE

# Enable the swap file
sudo swapon $SWAP_FILE

# Ensure it's persistent by updating /etc/fstab
if ! grep -q "$SWAP_FILE" /etc/fstab; then
    echo "$SWAP_FILE none swap sw 0 0" | sudo tee -a /etc/fstab
fi

# Set swappiness for better performance
sudo sysctl vm.swappiness=10
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf

# Confirm swap setup
echo "Swap setup complete!"
sudo swapon --show
free -h

