#!/bin/bash

set -ex

# Install kali tools
apt-get update
apt-get install -y \
  kali-tools-top10 \
  autopsy \
  cutycapt \
  dirbuster \
  faraday \
  guymager \
  legion \
  ophcrack \
  ophcrack-cli \
  sqlitebrowser

# Install Kali Purple tools
# apt-get install -y \
# kali-themes-purple \
# kali-tools-identify \
# kali-tools-protect \
# kali-tools-detect \
# kali-tools-respond \
# kali-tools-recover

# Remove stuff we install later properly
apt-get purge -y \
  firefox-esr \
  chromium
rm -f /usr/share/xfce4/panel/plugins/power-manager-plugin.desktop

# Cleanup
rm -rf \
  /var/lib/apt/lists/* \
  /var/tmp/* \
  /tmp/*

# Reinstall menu
apt-get install --reinstall kali-menu
