#!/bin/bash

if [ "$SUDO_USER" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

ROOT="$USER_HOME/.config/dotfiles/scripts"

source "$ROOT/util.sh"

run_dnf_update() {
	run_step "Refreshing package metadata and upgrading system" "sudo dnf upgrade --refresh -y"
	run_step "Removing unneeded packages" "sudo dnf autoremove -y"
	run_step "Cleaning up package cache" "sudo dnf clean all"
}

update_flatpak_themes() {
	run_step "Updating flatpak xdg-data/themes" "sudo flatpak override --filesystem=xdg-data/themes"
	run_step "Masking flatpak theme: light" "sudo flatpak mask org.gtk.Gtk3theme.adw-gtk3"
	run_step "Masking flatpak theme: dark" "sudo flatpak mask org.gtk.Gtk3theme.adw-gtk3-dark"
	run_step "Granting flatpak access to gtk-3.0 config" "sudo flatpak override --filesystem=xdg-config/gtk-3.0"
	run_step "Granting flatpak access to gtk-4.0 config" "sudo flatpak override --filesystem=xdg-config/gtk-4.0"
}

for arg in "$@"; do
	case "$arg" in
		--run-dnf-update)
			run_dnf_update
			exit 0
			;;
		--update-flatpak-themes)
			update_flatpak_themes
			exit 0
			;;
		*)
			echo "Unknown option: $arg"
			echo "Available options:"
			echo "  --run-dnf-update"
			echo "  --update-flatpak-themes"
			exit 1
			;;
	esac
done
