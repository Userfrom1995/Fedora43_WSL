# Trigger WSL setup on first login
if [ ! -f /etc/wsl-done ] && [ "$(id -u)" -eq 0 ]; then
    /usr/local/bin/wsl-setup.sh
fi
