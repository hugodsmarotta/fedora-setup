#!/bin/bash

set -eo pipefail

. /etc/os-release

if [[ "$ID" != 'fedora' || "$VARIANT_ID" != 'workstation' || "$VERSION_ID" < 41 ]]; then
  echo 'This script is intended for Fedora Workstation 41 or higher.'
  exit 1
fi

echo 'Defaults timestamp_timeout = -1' | sudo tee /etc/sudoers.d/timeout >/dev/null

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

sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$VERSION_ID".noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$VERSION_ID".noarch.rpm

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo dnf update -y --refresh

sudo dnf swap -y --allowerasing ffmpeg-free ffmpeg

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo tee /etc/yum.repos.d/vscode.repo <<'EOF' >/dev/null
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

sudo dnf install -y code

sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install -y gh

sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

sudo systemctl enable --now docker
sudo gpasswd --add "$USER" docker

git config --global user.name 'Hugo Marotta'
git config --global user.email 'hugodsmarotta@proton.me'
git config --global core.editor 'code --wait'
git config --global init.defaultBranch 'main'

sudo dnf install -y \
  https://mega.nz/linux/repo/Fedora_"$VERSION_ID"/x86_64/megasync-Fedora_"$VERSION_ID".x86_64.rpm \
  https://mega.nz/linux/repo/Fedora_"$VERSION_ID"/x86_64/nautilus-megasync-Fedora_"$VERSION_ID".x86_64.rpm

sudo flatpak install -y flathub \
  com.mattjakeman.ExtensionManager \
  com.spotify.Client \
  md.obsidian.Obsidian \
  org.cryptomator.Cryptomator

sudo flatpak override --filesystem=host md.obsidian.Obsidian
