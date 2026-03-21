#!/bin/bash
# Fedora 43 WSL RootFS Builder

set -e

EXPORT_DIR="/home/myuser/Fedora42_WSL/fedora43/rootfs"
OVERLAY_DIR="/home/myuser/Fedora42_WSL/fedora43/rootfs-overlay"
RELEASE_VER="43"

echo "Creating Fedora $RELEASE_VER rootfs in $EXPORT_DIR..."
mkdir -p "$EXPORT_DIR"

# Build the rootfs using dnf5 --installroot
echo "Initializing rootfs with fedora-release and fedora-repos..."
sudo dnf5 install --installroot="$EXPORT_DIR" \
  --releasever="$RELEASE_VER" \
  --setopt=install_weak_deps=False \
  --disablerepo="*" --enablerepo="fedora,updates" \
  --use-host-config \
  --nodocs -y fedora-release fedora-repos

echo "Installing core packages..."
sudo dnf5 install --installroot="$EXPORT_DIR" \
  --releasever="$RELEASE_VER" \
  --setopt=install_weak_deps=False \
  --disablerepo="*" --enablerepo="fedora,updates" \
  --use-host-config \
  --nodocs -y \
  @core sudo passwd shadow-utils util-linux dnf5 iputils findutils cracklib-dicts \
  dbus-broker dbus-daemon polkit systemd-pam

# Verify that bash exists
if [ ! -f "$EXPORT_DIR/usr/bin/bash" ]; then
    echo "ERROR: /usr/bin/bash not found in rootfs! Build failed."
    exit 1
fi

# Apply overlay
echo "Applying WSL overlay..."
if [ -d "$OVERLAY_DIR" ]; then
    sudo cp -r "$OVERLAY_DIR"/* "$EXPORT_DIR"/
fi

# # Disable problematic services for WSL
# echo "Disabling problematic services..."
# sudo chroot "$EXPORT_DIR" systemctl mask systemd-networkd-wait-online.service
# sudo chroot "$EXPORT_DIR" systemctl enable dbus-broker.service

# Set permissions for the setup script
sudo chmod +x "$EXPORT_DIR/usr/local/bin/wsl-setup.sh"

# Final cleanup
echo "Cleaning up..."
sudo dnf5 --installroot="$EXPORT_DIR" clean all
sudo rm -rf "$EXPORT_DIR/var/cache/dnf"

echo "RootFS built successfully in $EXPORT_DIR"
echo "To pack: cd $EXPORT_DIR && sudo tar --numeric-owner -czf ../Fedora$RELEASE_VER-WSL.tar.gz ."
