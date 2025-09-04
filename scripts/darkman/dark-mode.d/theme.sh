#!/bin/bash

GTK_THEME="adw-gtk3-dark"

enable_dark_mode() {
	if [ -n "$SUDO_USER" ]; then
		USER_NAME="$SUDO_USER"
	else
		USER_NAME="$USER"
	fi

	USER_HOME=$(eval echo "~$USER_NAME")
	USER_ID=$(id -u "$USER_NAME")
	DBUS_ADDR="unix:path=/run/user/$USER_ID/bus"

	sudo -u "$USER_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" \
		gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"

	sudo -u "$USER_NAME" crudini --set "$USER_HOME/.config/gtk-3.0/settings.ini" Settings gtk-theme-name "$GTK_THEME"

	if [ -f "$USER_HOME/.gtkrc-2.0" ]; then
		sudo -u "$USER_NAME" sed -i "s/^gtk-theme-name=\".*\"/gtk-theme-name=\"$GTK_THEME\"/" "$USER_HOME/.gtkrc-2.0"
	fi

	sudo -u "$USER_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" \
		gsettings set org.gnome.desktop.interface color-scheme prefer-dark

	sudo -u "$USER_NAME" crudini --set "$USER_HOME/.config/gtk-3.0/settings.ini" Settings gtk-application-prefer-dark-theme true
}

for arg in "$@"; do
case $arg in
  --force)
	enable_dark_mode
	shift
	;;
  *)
	echo "Unknown option: $arg"
	exit 1
	;;
esac
done