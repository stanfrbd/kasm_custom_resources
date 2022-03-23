#!/usr/bin/env bash
set -ex

CHROME_ARGS="--password-store=basic --no-sandbox  --ignore-gpu-blocklist --user-data-dir --no-first-run --simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'"

apt-get update
apt-get install -y software-properties-common
apt-get install -y chromium

mv /usr/bin/chromium /usr/bin/chromium-orig
cat >/usr/bin/chromium <<EOL
#!/usr/bin/env bash
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"None"/' ~/.config/chromium/Default/Preferences
/usr/bin/chromium-browser-orig ${CHROME_ARGS} "\$@"
EOL
chmod +x /usr/bin/chromium
cp /usr/bin/chromium /usr/bin/chromium-browser

cp /usr/share/applications/chromium.desktop $HOME/Desktop/
chown 1000:1000 $HOME/Desktop/chromium.desktop
