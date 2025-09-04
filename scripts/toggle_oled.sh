#!/bin/bash

OLED_CSS="$HOME/Desktop/dotfiles/css/oled.css"
GTK3_DIRECTORY="$HOME/.local/share/themes/adw-gtk3/gtk-3.0"
GTK4_DIRECTORY="$HOME/.local/share/themes/adw-gtk3/gtk-4.0"

apply_oled_to_gtk3() {
	local css_file="$GTK3_DIRECTORY/gtk-dark.css"
	local backup_file="$GTK3_DIRECTORY/gtk-dark.css.bak"

	if [ ! -f "$css_file" ]; then
		echo "GTK 3: gtk-dark.css not found in $GTK3_DIRECTORY"
		return
	fi

	if [ ! -f "$OLED_CSS" ]; then
		echo "OLED CSS not found at: $OLED_CSS"
		return
	fi

	if [ ! -f "$backup_file" ]; then
		cp "$css_file" "$backup_file"
	else
		cp "$backup_file" "$css_file"
	fi

	echo "Appending OLED CSS to GTK 3 theme"
	cat "$OLED_CSS" >> "$css_file"
}

apply_oled_to_gtk4() {
	local css_file="$GTK4_DIRECTORY/gtk-dark.css"
	local backup_file="$GTK4_DIRECTORY/gtk-dark.css.bak"
	local import_line="@import url(\"$OLED_CSS\");"

	if [ ! -f "$css_file" ]; then
		echo "GTK 4: gtk-dark.css not found in $GTK4_DIRECTORY"
		return
	fi

	if [ ! -f "$OLED_CSS" ]; then
		echo "OLED CSS not found at: $OLED_CSS"
		return
	fi

	if [ ! -f "$backup_file" ]; then
		cp "$css_file" "$backup_file"
	else
		cp "$backup_file" "$css_file"
	fi

	if ! grep -Fq "$import_line" "$css_file"; then
		echo "Importing OLED CSS into GTK 4 theme"
		echo "" >> "$css_file"
		echo "$import_line" >> "$css_file"
	else
		echo "OLED CSS already imported in GTK 4 theme"
	fi
}

enable_oled_mode() {
	echo "Enabling OLED mode..."
	apply_oled_to_gtk3
	apply_oled_to_gtk4
}
