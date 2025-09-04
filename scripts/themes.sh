#!/bin/bash

ADW_GTK_URL="https://github.com/lassekongo83/adw-gtk3/releases/download/v6.2/adw-gtk3v6.2.tar.gz"

if [ "$SUDO_USER" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

# ROOT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIRECTORY="$USER_HOME/.config/dotfiles"
TEMPORARY_DIRECTORY="$ROOT_DIRECTORY/temporary"
THEMES_DIRECTORY="$USER_HOME/.local/share/themes"

install_gtk_theme() {
	if [ ! -d "$THEMES_DIRECTORY/adw-gtk3" ] && [ ! -d "$THEMES_DIRECTORY/adw-gtk3-dark" ]; then
		adw_archive="$ROOT_DIRECTORY/adw-gtk3.tar.gz"
		if curl -L "$ADW_GTK_URL" -o "$adw_archive"; then
		mkdir -p "$TEMPORARY_DIRECTORY"
		tar -xzf "$adw_archive" -C "$TEMPORARY_DIRECTORY"

		ADW_EXTRACT_DIR="$TEMPORARY_DIRECTORY/adw-gtk3v6.2/themes"
		if [ -d "$ADW_EXTRACT_DIR/adw-gtk3" ] && [ -d "$ADW_EXTRACT_DIR/adw-gtk3-dark" ]; then
			mkdir -p "$THEMES_DIRECTORY"
			mv "$ADW_EXTRACT_DIR/adw-gtk3" "$THEMES_DIRECTORY"
			mv "$ADW_EXTRACT_DIR/adw-gtk3-dark" "$THEMES_DIRECTORY"
		fi
		rm -rf "$adw_archive"
		rm -rf "$TEMPORARY_DIRECTORY"
		fi
	fi
}

install_gtk_theme