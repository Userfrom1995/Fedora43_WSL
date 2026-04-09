#!/bin/bash

set -euo pipefail

DEFAULT_UID="1000"
DEFAULT_GROUPS="wheel"

echo "=========================================="
echo "   Welcome to Fedora 43 for WSL!          "
echo "=========================================="
echo
echo "Create your default Linux user account."
echo "This account does not need to match your Windows username."
echo

if getent passwd "$DEFAULT_UID" >/dev/null; then
    echo "A default user already exists. Skipping first-run setup."
    exit 0
fi

while true; do
    read -r -p "Enter username for the new account: " new_user

    if [[ ! "$new_user" =~ ^[a-z][-a-z0-9]*$ ]]; then
        echo "Invalid username. Use lowercase letters, numbers, and hyphens, starting with a letter."
        continue
    fi

    if id "$new_user" >/dev/null 2>&1; then
        echo "That username already exists. Choose another one."
        continue
    fi

    if useradd --create-home --uid "$DEFAULT_UID" --groups "$DEFAULT_GROUPS" "$new_user"; then
        break
    fi

    echo "Unable to create '$new_user'. Choose another username."
done

echo "Please set a password for $new_user:"
passwd "$new_user"

if grep -q '^\[user\]' /etc/wsl.conf; then
    sed -i '/^\[user\]/,/^$/d' /etc/wsl.conf
fi
printf '\n[user]\ndefault=%s\n' "$new_user" >> /etc/wsl.conf

echo
echo "Setup complete. Restart the distribution if you need a fresh systemd session."
