#!/bin/bash

# Enable date stamp for history for all users
echo "Configuring history timestamp format for all users..."
HIST_CONFIG='export HISTTIMEFORMAT="%F %T "'
if ! grep -q "$HIST_CONFIG" /etc/profile; then
    echo "$HIST_CONFIG" | tee -a /etc/profile > /dev/null
fi

# Set open file limit to maximum for all users
echo "Setting open file limits..."
LIMITS_CONF="/etc/security/limits.conf"
LIMITS_D="/etc/security/limits.d/custom_limits.conf"

# Remove any existing nofile entries
sed -i '/\*.*nofile/d' $LIMITS_CONF

# Append new limits
echo -e "* soft nofile 1048576\n* hard nofile 1048576" | tee -a $LIMITS_CONF > /dev/null

# Ensure PAM limits module is enabled
if ! grep -q "session required pam_limits.so" /etc/pam.d/common-session; then
    echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session > /dev/null
fi

if ! grep -q "session required pam_limits.so" /etc/pam.d/common-session-noninteractive; then
    echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session-noninteractive > /dev/null
fi

# Update system-wide limits
echo "fs.file-max = 1048576" | tee -a /etc/sysctl.conf > /dev/null
sysctl -p

# Apply limits to login shells
echo -e "ulimit -n 1048576" | tee -a /etc/profile > /dev/null

echo "Configuration complete. Please reboot for changes to take full effect."

