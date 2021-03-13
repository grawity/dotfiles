#!/usr/bin/env bash

really=0
if [[ "$1" == "-y" ]]; then
	really=1; shift
fi

if [[ -d ~/lib/dotfiles && ! -d ~/.dotfiles ]]; then
	echo "Moving dotfiles directory"
	mv -v ~/lib/dotfiles ~/.dotfiles
fi

dirs=(~ ~/.config/ ~/.cache/ ~/.local/share/)

find "${dirs[@]}" -maxdepth 2 -type l | sort -u | while read -r path; do
	linkdir=$(dirname "$path")
	target=$(readlink "$path")
	if [[ "$target" != *lib/dotfiles* ]]; then
		continue
	fi
	newtarget=${target/'lib/dotfiles/'/'.dotfiles/'}
	#newtarget=$(readlink -f "$path")
	#newtarget=$(realpath --relative-to="$linkdir" "$newtarget")
	if [[ "$target" == "$newtarget" ]]; then
		continue
	fi
	if (( really )); then
		ln -vnsf "$newtarget" "$path"
	else
		echo "OLD: $path -> $target"
		echo "NEW: $path -> $newtarget"
	fi
	echo
done
