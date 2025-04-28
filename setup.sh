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
