#!/bin/bash

# OLED theme file
OLED_CSS="gtk-oled.css"

# GTK CSS paths
GTK3_CSS="$HOME/.config/gtk-3.0/gtk.css"
GTK4_CSS="$HOME/.config/gtk-4.0/gtk.css"

# Backup paths
GTK3_BAK="${GTK3_CSS}.bak"
GTK4_BAK="${GTK4_CSS}.bak"

backup_file() {
    local file="$1"
    local backup="$2"
    local label="$3"

    if [[ -f "$file" ]]; then
        cp "$file" "$backup"
        echo "[$label] Backup created at: $backup"
    fi
}

append_if_missing() {
    local file="$1"
    local backup="$2"
    local label="$3"

    mkdir -p "$(dirname "$file")"

    if [[ ! -f "$OLED_CSS" ]]; then
        echo "Error: '$OLED_CSS' not found."
        exit 1
    fi

    local oled_content
    oled_content=$(<"$OLED_CSS")

    if [[ -f "$file" ]] && grep -Fq "$oled_content" "$file"; then
        echo "[$label] OLED content already present. Skipping."
        return
    fi

    backup_file "$file" "$backup" "$label"

    {
        echo -e "\n/* --- Appended from gtk-oled.css --- */"
        echo "$oled_content"
    } >> "$file"

    echo "[$label] OLED content appended to $file"
}

restore_backup() {
    local file="$1"
    local backup="$2"
    local label="$3"

    if [[ -f "$backup" ]]; then
        cp "$backup" "$file"
        rm -f "$backup"
        echo "[$label] Restored from backup: $backup"
    else
        echo "[$label] No backup found to restore. Deleting $file"
        rm -f "$file"
    fi
}

if [[ "$1" == "--off" ]]; then
    echo "🔧 Disabling OLED theme and restoring backups..."
    restore_backup "$GTK3_CSS" "$GTK3_BAK" "GTK 3"
    restore_backup "$GTK4_CSS" "$GTK4_BAK" "GTK 4"
    exit 0
fi

append_if_missing "$GTK3_CSS" "$GTK3_BAK" "GTK 3"
append_if_missing "$GTK4_CSS" "$GTK4_BAK" "GTK 4"

# Update system theme and Flatpak overrides
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0
