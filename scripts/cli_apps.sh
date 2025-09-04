#!/bin/bash

if [ "$SUDO_USER" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

ROOT="$USER_HOME/.config/dotfiles/scripts"

source "$ROOT/util.sh"

install_cli_apps() {
	run_step "Installing sdkman" "curl -s https://get.sdkman.io | bash"
	run_step "Installing nvm" "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash"
	# run_step "Installing darkman" "dnf install -y darkman"

	# if [[ -z \"$SUDO_USER\" ]]; then
	# 	run_step "Enabling darkman.service" "systemctl --user enable --now darkman.service"
	# else
	# 	echo "ℹ️ To enable darkman.service, run:"
	# 	echo "systemctl --user enable --now darkman.service"
	# fi
}

for arg in "$@"; do
	case "$arg" in
		--install-cli-apps)
			install_cli_apps
			exit 0
			;;
		--remove-cli-apps)
			exit 0
			;;
		*)
			echo "Unknown option: $arg"
			echo "Available options:"
			echo "  --install_cli_apps"
			echo "  --remove-cli-apps"
			exit 1
			;;
	esac
done