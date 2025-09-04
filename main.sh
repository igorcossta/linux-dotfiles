#!/bin/bash
set -e

# if [[ $EUID -ne 0 ]]; then
# 	echo "This script must be run as root. Use sudo."
# 	exit 1
# fi

if [ "$SUDO_USER" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

ROOT="$USER_HOME/.config/dotfiles/scripts"

source "$ROOT/util.sh"

reset_everything() {
	# to remove gnome extensions and their settings via command line
	# rm -rf ~/.local/share/gnome-shell/extensions/* && dconf reset -f /org/gnome/shell/extensions/
	
	# to remove gnome extensions via gdbus
	# gdbus call --session --dest org.gnome.Shell.Extensions \
	#   --object-path /org/gnome/Shell/Extensions \
	#   --method org.gnome.Shell.Extensions.UninstallExtension "extension_uuid"
	echo 'Bazinga!'
}

# Use dconf dump to export settings under /org/gnome/shell/extensions/:
# mkdir -p ~/gnome-extension-backup
# dconf dump /org/gnome/shell/extensions/ > ~/gnome-extension-backup/extensions.dconf

# To restore the settings back:
# dconf load /org/gnome/shell/extensions/ < ~/gnome-extension-backup/extensions.dconf

# If you want per-extension backup files, you can loop like this:
# backup_dir=~/gnome-extension-backup
# mkdir -p "$backup_dir"

# extensions=$(dconf list /org/gnome/shell/extensions/)
# for ext in $extensions; do
#   dconf dump /org/gnome/shell/extensions/$ext > "$backup_dir/${ext}.dconf"
# done
# dconf load /org/gnome/shell/extensions/blur-my-shell/ < ~/gnome-extension-backup/blur-my-shell.dconf

init() {
	sudo $ROOT/update_system.sh --run-dnf-update
	$ROOT/flatpak_apps.sh --install-flatpaks
	$ROOT/extensions.sh --install-extensions
	$ROOT/cli_apps.sh --install-cli-apps
	$ROOT/themes.sh
	sudo $ROOT/update_system.sh --update-flatpak-themes
	run_step "Enabling light mode" "$ROOT/darkman/light-mode.d/theme.sh --force"
}

init
