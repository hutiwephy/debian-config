#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]; then echo "ERROR: root permissions required!" >&2; exit 1; fi

# install gnome
apt install gnome-core gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dashtodock

# add global config profile
cat >/etc/dconf/profile/user <<EOL
user-db:user
system-db:local
EOL

# add default settings
mkdir -p /etc/dconf/db/local.d
cat >/etc/dconf/db/local.d/00-extensions <<EOL
[org/gnome/shell]
enabled-extensions=['dash-to-dock@micxgx.gmail.com', 'ding@rastersoft.com']
favorite-apps=['firefox-esr.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Software.desktop']

[org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
use-theme-colors=false
foreground-color='rgb(208,207,204)'
background-color='rgb(23,20,33)'

[org/gnome/shell/extensions/dash-to-dock]
dash-max-icon-size=48
extend-height=true
icon-size-fixed=true
dock-position='LEFT'
dock-fixed=true

[org/gnome/desktop/peripherals/touchpad]
tap-to-click=true

[org/gtk/gtk4/settings/file-chooser]
sort-directories-first=true

[org/gnome/TextEditor]
restore-session=false
EOL

# update configuration
dconf update

# set network as managed (fix no network icon)
cat >/etc/NetworkManager/NetworkManager.conf <<EOL
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
EOL
systemctl restart NetworkManager
