#!/bin/bash

# Only run if setup is not done and we are root
if [ ! -f /etc/wsl-done ] && [ "$(id -u)" -eq 0 ]; then
    echo "=========================================="
    echo "   Welcome to Fedora 43 for WSL!          "
    echo "=========================================="
    echo ""
    echo "Setting up your initial user account..."
    echo ""

    # Prompt for username
    while true; do
        read -p "Enter username for the new account: " NEW_USER
        if [[ "$NEW_USER" =~ ^[a-z][-a-z0-9]*$ ]]; then
            break
        else
            echo "Invalid username. Use only lowercase, numbers, and hyphens, starting with a letter."
        fi
    done

    # Create user and add to wheel (sudoers)
    useradd -m -G wheel "$NEW_USER"
    
    # Set password
    echo "Please set a password for $NEW_USER:"
    passwd "$NEW_USER"

    # Set as default user in wsl.conf
    # Remove existing [user] section if present and replace
    sed -i '/^\[user\]/d' /etc/wsl.conf
    sed -i '/^default=/d' /etc/wsl.conf
    echo -e "\n[user]\ndefault=$NEW_USER" >> /etc/wsl.conf

    # Mark as done
    touch /etc/wsl-done

    echo ""
    echo "Setup complete! Switching to user '$NEW_USER'..."
    echo "Note: For a fully clean systemd session, you can run 'wsl --terminate <distro>' later."
    echo "=========================================="
    
    # Switch to the new user immediately
    exec su -l "$NEW_USER"
fi
