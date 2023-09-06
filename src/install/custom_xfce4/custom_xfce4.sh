#!/bin/bash

set -ex

#xfconf-query -c xsettings -p /Net/ThemeName -s Kali-Purple-Dark
#xfconf-query -c xsettings -p /Net/IconThemeName -s Flat-Remix-Purple-Dark
#xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/last-image -s /usr/share/backgrounds/kali-16x9/kali-purple.png

sed -i -e "s/\/usr\/share\/backgrounds\/kali-16x9\/default/\/usr\/share\/backgrounds\/kali-16x9\/kali-purple.png/g" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

