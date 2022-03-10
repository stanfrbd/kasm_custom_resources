#!/usr/bin/env bash
set -ex

CHROME_ARGS="--password-store=basic --no-sandbox  --ignore-gpu-blocklist --user-data-dir --no-first-run --simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'"

apt-get update
apt-get install -y software-properties-common
apt-get install -y chromium

sed -i 's/-stable//g' /usr/share/applications/chromium.desktop

cp /usr/share/applications/chromium.desktop $HOME/Desktop/
chown 1000:1000 $HOME/Desktop/chromium.desktop
