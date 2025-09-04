#!/bin/bash

# run_step() {
# 	local name="$1"
# 	local cmd="$2" # command to run

# 	echo -ne "➡️ $name...\r"
# 	eval "$cmd" >/dev/null 2>&1
# 	echo -e "✅ $name"
# }

run_step() {
	local name="$1" # step description
	local cmd="$2" # command to run

	echo -ne "➡️ $name\r"
	if eval "$cmd" >/dev/null 2>&1; then
		echo -e "✅ $name"
	else
		echo -e "❌ $name"
	fi
}
