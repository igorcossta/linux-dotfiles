#!/bin/bash

if [ "$SUDO_USER" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

ROOT="$USER_HOME/.config/dotfiles/scripts"

source "$ROOT/util.sh"

# https://extensions.gnome.org/extension/4158/gnome-40-ui-improvements/
# https://extensions.gnome.org/extension/3193/blur-my-shell/
# https://extensions.gnome.org/extension/4470/media-controls/
# https://extensions.gnome.org/extension/7865/open-desktop-file-location/
# https://extensions.gnome.org/extension/6580/open-bar/
# https://extensions.gnome.org/extension/7266/lilypad/
# https://extensions.gnome.org/extension/7012/custom-command-toggle/
# https://extensions.gnome.org/extension/7048/rounded-window-corners-reborn/
# https://extensions.gnome.org/extension/3843/just-perfection/
# https://extensions.gnome.org/extension/3628/arcmenu/
# https://extensions.gnome.org/extension/3396/color-picker/
# https://extensions.gnome.org/extension/4481/forge/

install_shell_extensions() {
	  # "openbar@neuromorph"
	extensions=(
	  "open-desktop-location@laura.media"
	  "blur-my-shell@aunetx"
	  "custom-command-toggle@storageb.github.com"
	  "gnome-ui-tune@itstime.tech"
	  "lilypad@shendrew.github.io"
	  "mediacontrols@cliffniff.github.com"
	  "rounded-window-corners@fxgn"
	  "just-perfection-desktop@just-perfection"
	  "arcmenu@arcmenu.com"
	  "kando-integration@kando-menu.github.io"
	  "color-picker@tuberry"
	  "forge@jmmaranan.com"
	)
	for extension in "${extensions[@]}"; do
	 gdbus call --session --dest org.gnome.Shell.Extensions \
			 --object-path /org/gnome/Shell/Extensions \
			 --method org.gnome.Shell.Extensions.InstallRemoteExtension "$extension"
	done
}

for arg in "$@"; do
	case "$arg" in
		--install-extensions)
			install_shell_extensions
			exit 0
			;;
		--remove-extensions)
			exit 0
			;;
		*)
			echo "Unknown option: $arg"
			echo "Available options:"
			echo "  --install-extensions"
			echo "  --remove-extensions"
			exit 1
			;;
	esac
done
