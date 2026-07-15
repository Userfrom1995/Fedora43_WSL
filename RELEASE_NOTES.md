Release Notes: Fedora Rawhide for WSL
======================================

This release switches the distro from a fixed Fedora 43 base to Fedora
Rawhide's rolling repository, eliminating the need for manual version
bumps. The first-run experience and build pipeline have been reworked
to match Fedora's official WSL packaging patterns.

Highlights
----------

* Switched from Fedora 43 to Fedora Rawhide -- no more version bumps
* First-run user creation with cloud-init awareness
* NOPASSWD sudo via dedicated sudoers file (password optional)
* Grants the created user sudo access through the wheel group
* Adopted the official wsl-setup config: X11/Wayland/PulseAudio
  tmpfiles, systemd-firstboot override, and improved OOBE script
* Pre-imports the Rawhide signing key from distribution-gpg-keys
  -- avoids stale-key failures when Rawhide bumps releases
* Removed the custom oobe.sh password prompt in favor of NOPASSWD
  sudo with documented opt-in password setup
* Renamed the distro default name to fedora-rawhide
* Renamed the build directory and output filename for consistency
* Updated the build script to use distribution-gpg-keys for GPG
  key handling, matching the approach used by Fedora's KIWI and
  image-builder tools

Fedora Rawhide for WSL is now here, tracking the latest Rawhide
development snapshot with every build. On first launch, you create
your own Linux user with passwordless sudo access -- no more waiting
for a Fedora release bump to get the latest packages.
