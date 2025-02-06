#!/bin/bash

set -eo pipefail

# Disable sudo timeout
echo "Defaults timestamp_timeout = -1" | sudo tee /etc/sudoers.d/timeout >/dev/null

# Limit DNF to 10 parallel downloads
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf >/dev/null

# Enable RPM Fusion repositories
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

# Enable Flathub repository
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
