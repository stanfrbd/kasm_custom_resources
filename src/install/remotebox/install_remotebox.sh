#!/usr/bin/env bash

# Install RemoteBox version 3.1 (VirtualBox 6.1)

set -ex

apt-get update
apt-get install -y libgtk3-perl libsoap-lite-perl freerdp2-x11 tigervnc-viewer imagemagick

wget "https://remotebox.knobgoblin.org.uk/downloads/RemoteBox-3.2.tar.bz2"

tar -xvf RemoteBox-3.2.tar.bz2 -C /opt

convert /opt/RemoteBox-3.2/packagers-readme/remotebox.ico /opt/RemoteBox-3.2/packagers-readme/remotebox.png

echo "[Desktop Entry]
Name=RemoteBox
Comment=Remote VirtualBox client
Exec=/opt/RemoteBox-3.2/remotebox
Icon=/opt/RemoteBox-3.2/packagers-readme/remotebox-8.png
Terminal=false
Type=Application
StartupNotify=false
Categories=Emulator;System;
Path=/opt/RemoteBox-3.2" > remotebox.desktop

chown 1000:1000 /opt/RemoteBox-3.2

mv remotebox.desktop $HOME/Desktop
chmod +x $HOME/Desktop/remotebox.desktop
chown 1000:1000 $HOME/Desktop/remotebox.desktop

rm -rf RemoteBox-3.2.tar.bz2
