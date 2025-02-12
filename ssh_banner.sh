#!/bin/bash

BANNER_FILE="/etc/motd"
ISSUE_FILE="/etc/issue"
ISSUE_NET_FILE="/etc/issue.net"

# Define the simple warning banner
BANNER_TEXT="
********************************************************************
*                                                                  *
*                      ⚠️  WARNING  ⚠️                               *
*                                                                  *
*  This server is monitored by PurpleTalk.                        *
*  All activities are logged and reviewed regularly.               *
*  If you are an unauthorized user, please LOG OUT immediately.   *
*                                                                  *
*  Unauthorized access is strictly prohibited.                     *
*  Violations will be reported and may lead to disciplinary action. *
*                                                                  *
********************************************************************
"

# Set banner for local login sessions
echo "$BANNER_TEXT" | sudo tee $BANNER_FILE > /dev/null

# Set banner for console login
echo "$BANNER_TEXT" | sudo tee $ISSUE_FILE > /dev/null

# Set banner for SSH remote login
echo "$BANNER_TEXT" | sudo tee $ISSUE_NET_FILE > /dev/null

# Ensure SSH is configured to show the banner
SSH_CONFIG="/etc/ssh/sshd_config"
if ! grep -q "^Banner $ISSUE_NET_FILE" $SSH_CONFIG; then
    echo "Banner $ISSUE_NET_FILE" | sudo tee -a $SSH_CONFIG > /dev/null
    sudo systemctl restart ssh
fi

echo "🚨 Simple warning login banner has been set successfully! 🚨"

