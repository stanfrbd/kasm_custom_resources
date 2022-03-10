#!/usr/bin/env bash
set -ex

CHROME_ARGS="--password-store=basic --no-sandbox  --ignore-gpu-blocklist --user-data-dir --no-first-run --simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'"

apt-get update
apt-get install -y software-properties-common
apt-get install -y chromium

sed -i 's/-stable//g' /usr/share/applications/chromium.desktop

cp /usr/share/applications/chromium.desktop $HOME/Desktop/
chown 1000:1000 $HOME/Desktop/chromium.desktop

mv /usr/bin/chromium /usr/bin/chromium-orig
cat >/usr/bin/chromium <<EOL
#!/usr/bin/env bash
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"None"/' ~/.config/chromium/Default/Preferences
/usr/bin/chromium-orig ${CHROME_ARGS} "\$@"
EOL
chmod +x /usr/bin/chromium
cp /usr/bin/chromium /usr/bin/chromium

if [ "$DISTRO" = centos ]; then
  cat >> $HOME/.config/mimeapps.list <<EOF
    [Default Applications]
    x-scheme-handler/http=chromium.desktop
    x-scheme-handler/https=chromium.desktop
    x-scheme-handler/ftp=chromium.desktop
    x-scheme-handler/chrome=chromium.desktop
    text/html=chromium.desktop
    application/x-extension-htm=chromium.desktop
    application/x-extension-html=chromium.desktop
    application/x-extension-shtml=chromium.desktop
    application/xhtml+xml=chromium.desktop
    application/x-extension-xhtml=chromium.desktop
    application/x-extension-xht=chromium.desktop
EOF
else
  sed -i 's@exec -a "$0" "$HERE/chromium" "$\@"@@g' /usr/bin/x-www-browser
  cat >>/usr/bin/x-www-browser <<EOL
  exec -a "\$0" "\$HERE/chromium" "${CHROME_ARGS}"  "\$@"
EOL
fi

mkdir -p /etc/chromium/policies/managed/
cat >>/etc/chromium/policies/managed/default_managed_policy.json <<EOL
{"CommandLineFlagSecurityWarningsEnabled": false, "DefaultBrowserSettingEnabled": false}
EOL
