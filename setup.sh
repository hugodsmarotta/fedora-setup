#!/bin/bash

set -eo pipefail

# Disable sudo timeout
echo "Defaults timestamp_timeout = -1" | sudo tee /etc/sudoers.d/timeout >/dev/null

# Limit DNF to 10 parallel downloads
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf >/dev/null

# Remove unnecessary packages
sudo dnf remove -y \
  baobab \
  firefox* \
  gnome-abrt \
  gnome-boxes \
  gnome-calendar \
  gnome-characters \
  gnome-clocks \
  gnome-color-manager \
  gnome-connections \
  gnome-contacts \
  gnome-disk-utility \
  gnome-font-viewer \
  gnome-logs \
  gnome-maps \
  gnome-system-monitor \
  gnome-tour \
  gnome-weather \
  ibus-anthy \
  ibus-hangul \
  ibus-libpinyin \
  ibus-m17n \
  ibus-typing-booster \
  libreoffice* \
  mediawriter \
  rhythmbox \
  simple-scan \
  snapshot \
  yelp

# Enable RPM Fusion repositories
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

# Enable Flathub repository
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Update the system
sudo dnf update -y --refresh

# Install development tools
sudo dnf install -y @development-tools

# Install Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<"EOF"
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

sudo dnf install -y code

# Install GitHub CLI
sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install -y gh

# Install Docker
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

# Enable Docker to start on boot
sudo systemctl enable --now docker

# Enable Docker usage without sudo
getent group docker >/dev/null || sudo groupadd docker
sudo gpasswd -a "$USER" docker
