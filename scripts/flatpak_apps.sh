#!/bin/bash

if [ "$SUDO_USER" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

ROOT="$USER_HOME/.config/dotfiles/scripts"

source "$ROOT/util.sh"

install_flatpak_apps() {
	apps=(
		"com.mattjakeman.ExtensionManager"
		"io.github.zaedus.spider"
		"io.github.giantpinkrobots.varia"
		"re.sonny.Commit"
		"me.iepure.devtoolbox"
		"com.github.ADBeveridge.Raider"
		"org.gnome.DejaDup"
		"me.dusansimic.DynamicWallpaper"
		"menu.kando.Kando"
		"be.alexandervanhee.gradia"
		"org.localsend.localsend_app"
		"io.github.jeffshee.Hidamari"
		"com.rafaelmardojai.Blanket"
		"com.pojtinger.felicitas.Sessions"
		"app.zen_browser.zen"
		"org.gnome.Builder"
	)
	for app in "${apps[@]}"; do
		run_step "Installing $app" "flatpak install -y flathub $app"
	done
}

for arg in "$@"; do
	case "$arg" in
		--install-flatpaks)
			install_flatpak_apps
			exit 0
			;;
		--remove-flatpaks)
			exit 0
			;;
		*)
			echo "Unknown option: $arg"
			echo "Available options:"
			echo "  --install-flatpaks"
			echo "  --remove-flatpaks"
			exit 1
			;;
	esac
done
