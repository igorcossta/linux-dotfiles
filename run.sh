#!/bin/bash

# Setup script for my Linux environment

# URLs
adw_gtk3_url="https://github.com/lassekongo83/adw-gtk3/releases/download/v6.2/adw-gtk3v6.2.tar.gz"

# Directories
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SIDEBAR_CSS="$SCRIPT_DIR/sidebar.css.off"
MEDIA_CONTROL_EXT_URL="https://github.com/LauraWebdev/open-desktop-location/releases/download/v1.0.1/open-desktop-location@laura.media.shell-extension.zip"

THEMES_DIR="$HOME/.local/share/themes"
EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions"

TEMP_EXTRACT_DIR="$SCRIPT_DIR/temp_extract"

# GTK config paths
GTK4_CSS="$HOME/.config/gtk-4.0/gtk.css"
GTK3_CSS="$HOME/.config/gtk-3.0/gtk.css"

mkdir -p "$TEMP_EXTRACT_DIR"

# Install adw-gtk3 themes if not already installed
if [ ! -d "$THEMES_DIR/adw-gtk3" ] && [ ! -d "$THEMES_DIR/adw-gtk3-dark" ]; then
    adw_archive="$SCRIPT_DIR/adw-gtk3.tar.gz"
    if curl -L "$adw_gtk3_url" -o "$adw_archive"; then
        tar -xzf "$adw_archive" -C "$TEMP_EXTRACT_DIR"

        ADW_EXTRACT_DIR="$TEMP_EXTRACT_DIR/adw-gtk3v6.2/themes"
        if [ -d "$ADW_EXTRACT_DIR/adw-gtk3" ] && [ -d "$ADW_EXTRACT_DIR/adw-gtk3-dark" ]; then
            mkdir -p "$THEMES_DIR"
            mv "$ADW_EXTRACT_DIR/adw-gtk3" "$THEMES_DIR"
            mv "$ADW_EXTRACT_DIR/adw-gtk3-dark" "$THEMES_DIR"
        fi
        rm -rf "$adw_archive"
    fi
fi

# Apply sidebar.css to GTK configs
if [ -f "$SIDEBAR_CSS" ]; then
    for css_file in "$GTK4_CSS" "$GTK3_CSS"; do
        mkdir -p "$(dirname "$css_file")"
        [ -f "$css_file" ] && cp "$css_file" "$css_file.bak"
        printf "\n/* Added by setup script - sidebar styles */\n" >> "$css_file"
        cat "$SIDEBAR_CSS" >> "$css_file"
    done
fi

# gnome extensions
# https://extensions.gnome.org/extension/4158/gnome-40-ui-improvements/
# https://extensions.gnome.org/extension/3193/blur-my-shell/
# https://extensions.gnome.org/extension/4470/media-controls/
# https://extensions.gnome.org/extension/7865/open-desktop-file-location/
# https://extensions.gnome.org/extension/6580/open-bar/
# https://extensions.gnome.org/extension/7266/lilypad/
# https://extensions.gnome.org/extension/7012/custom-command-toggle/
# https://extensions.gnome.org/extension/7048/rounded-window-corners-reborn/
download_and_enable_gnome_extension() {
    extensions=(
      "open-desktop-location@laura.media"
      "blur-my-shell@aunetx"
      "custom-command-toggle@storageb.github.com"
      "gnome-ui-tune@itstime.tech"
      "lilypad@shendrew.github.io"
      "mediacontrols@cliffniff.github.com"
      "openbar@neuromorph"
      "rounded-window-corners@fxgn"
    )

    for extension in "${extensions[@]}"; do
        gdbus call --session --dest org.gnome.Shell.Extensions \
            --object-path /org/gnome/Shell/Extensions \
            --method org.gnome.Shell.Extensions.InstallRemoteExtension "$extension"
        for i in {1..10}; do
            if is_extension_installed "$extension"; then
                break
            fi
            sleep 1
        done
    done
}

is_extension_installed() {
  local ext_uuid=$1
  gnome-extensions list | grep -qx "$ext_uuid"
}

# Install Flatpak applications
install_flatpak_apps() {
    apps=(
        "com.mattjakeman.ExtensionManager"
        "io.github.zaedus.spider"
        "io.github.giantpinkrobots.varia"
        "re.sonny.Commit"
        "me.iepure.devtoolbox"
    )
    for app in "${apps[@]}"; do
        flatpak install -y flathub "$app" >/dev/null 2>&1
    done
}

install_flatpak_apps
download_and_enable_gnome_extension

# Update system theme and Flatpak overrides
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.interface color-scheme 'default'

sudo flatpak override --filesystem=xdg-data/themes
sudo flatpak mask org.gtk.Gtk3theme.adw-gtk3
sudo flatpak mask org.gtk.Gtk3theme.adw-gtk3-dark

rm -rf "$TEMP_EXTRACT_DIR"
