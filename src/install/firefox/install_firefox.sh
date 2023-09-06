#!/usr/bin/env bash
set -xe

ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')

set_desktop_icon() {
  sed -i -e 's!Icon=.\+!Icon=/usr/share/icons/hicolor/48x48/apps/firefox.png!' "$HOME/Desktop/firefox.desktop"
}

echo "Install Firefox"
if [[ "${DISTRO}" == @(centos|oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|fedora37) ]]; then
  if [[ "${DISTRO}" == @(oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|fedora37) ]]; then
    dnf install -y firefox p11-kit
  else
    yum install -y firefox p11-kit
  fi
elif [ "${DISTRO}" == "opensuse" ]; then
  zypper install -yn p11-kit-tools MozillaFirefox
elif grep -q Jammy /etc/os-release; then
  if [ ! -f '/etc/apt/preferences.d/mozilla-firefox' ]; then
    add-apt-repository -y ppa:mozillateam/ppa
    echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' > /etc/apt/preferences.d/mozilla-firefox
  fi
  apt-get install -y firefox p11-kit-modules
elif grep -q "ID=debian" /etc/os-release || grep -q "ID=kali" /etc/os-release || grep -q "ID=parrot" /etc/os-release; then
  echo \
    "deb http://deb.debian.org/debian/ unstable main contrib non-free" >> \
    /etc/apt/sources.list
cat > /etc/apt/preferences.d/99pin-unstable <<EOF
Package: *
Pin: release a=stable
Pin-Priority: 900

Package: *
Pin: release a=unstable
Pin-Priority: 10
EOF
  apt-get update
  apt-get install -y -t unstable firefox p11-kit-modules
else
  apt-mark unhold firefox || :
  apt-get remove firefox
  apt-get update
  apt-get install -y firefox p11-kit-modules
fi

if [[ "${DISTRO}" == @(centos|oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|fedora37) ]]; then
  if [[ "${DISTRO}" == @(oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|fedora37) ]]; then
    dnf clean all
  else
    yum clean all
  fi
elif [ "${DISTRO}" == "opensuse" ]; then
  zypper clean --all
else
  if [ "$ARCH" == "arm64" ] && [ "$(lsb_release -cs)" == "focal" ] ; then
    echo "Firefox flash player not supported on arm64 Ubuntu Focal Skipping"
  elif grep -q "ID=debian" /etc/os-release || grep -q "ID=kali" /etc/os-release || grep -q "ID=parrot" /etc/os-release; then
    echo "Firefox flash player not supported on Debian"
  elif ! grep -q Jammy /etc/os-release; then
    # Plugin to support running flash videos for sites like vimeo
    apt-get update
    apt-get install -y browser-plugin-freshplayer-pepperflash
    apt-mark hold firefox
    apt-get clean -y
  fi
fi

if [[ "${DISTRO}" != @(centos|oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|opensuse|fedora37) ]]; then
  # Update firefox to utilize the system certificate store instead of the one that ships with firefox
  rm -f /usr/lib/firefox/libnssckbi.so
  ln /usr/lib/$(arch)-linux-gnu/pkcs11/p11-kit-trust.so /usr/lib/firefox/libnssckbi.so
fi

if [[ "${DISTRO}" == @(centos|oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|fedora37) ]]; then
  if [ "${DISTRO}" == "fedora37" ]; then
    preferences_file=/usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js
  else
    preferences_file=/usr/lib64/firefox/browser/defaults/preferences/all-redhat.js
  fi
  sed -i -e '/homepage/d' "$preferences_file"
elif [ "${DISTRO}" == "opensuse" ]; then
  preferences_file=/usr/lib64/firefox/browser/defaults/preferences/firefox.js
else
  preferences_file=/usr/lib/firefox/browser/defaults/preferences/firefox.js
fi
# Disabling default first run URL
cat >"$preferences_file" <<EOF
pref("datareporting.policy.firstRunURL", "");
pref("datareporting.policy.dataSubmissionEnabled", false);
pref("datareporting.healthreport.service.enabled", false);
pref("datareporting.healthreport.uploadEnabled", false);
pref("trailhead.firstrun.branches", "nofirstrun-empty");
pref("browser.aboutwelcome.enabled", false);
EOF

if [[ "${DISTRO}" == @(centos|oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|opensuse|fedora37) ]]; then
  # Creating a default profile
  firefox -headless -CreateProfile "kasm $HOME/.mozilla/firefox/kasm"
  # Generate a certdb to be detected on squid start
  HOME=/root firefox --headless &
  mkdir -p /root/.mozilla
  CERTDB=$(find  /root/.mozilla* -name "cert9.db")
  while [ -z "${CERTDB}" ] ; do
    sleep 1
    echo "waiting for certdb"
    CERTDB=$(find  /root/.mozilla* -name "cert9.db")
  done
  sleep 2
  kill $(pgrep firefox)
  CERTDIR=$(dirname ${CERTDB})
  mv ${CERTDB} $HOME/.mozilla/firefox/kasm/
  rm -Rf /root/.mozilla
else
  # Creating Default Profile
  firefox -headless -CreateProfile "kasm $HOME/.mozilla/firefox/kasm"
fi

if [[ "${DISTRO}" == @(centos|oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|opensuse|fedora37) ]]; then
  set_desktop_icon
fi

# Starting with version 67, Firefox creates a unique profile mapping per installation which is hash generated
#   based off the installation path. Because that path will be static for our deployments we can assume the hash
#   and thus assign our profile to the default for the installation

if [[ "${DISTRO}" != @(centos|oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|opensuse|fedora37) ]]; then
cat >>$HOME/.mozilla/firefox/profiles.ini <<EOL
[Install4F96D1932A9F858E]
Default=kasm
Locked=1
EOL
elif [[ "${DISTRO}" == @(centos|oracle8|rockylinux9|rockylinux8|oracle9|almalinux9|almalinux8|opensuse|fedora37) ]]; then
cat >>$HOME/.mozilla/firefox/profiles.ini <<EOL
[Install11457493C5A56847]
Default=kasm
Locked=1
EOL
fi

chown -R 1000:1000 $HOME/.mozilla
cp /usr/share/applications/firefox.desktop $HOME/Desktop/firefox.desktop
chown 1000:1000 $HOME/Desktop/firefox.desktop
chmod +x $HOME/Desktop/firefox.desktop

