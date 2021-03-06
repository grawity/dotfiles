#!/usr/bin/env bash

really=0
if [[ "$1" == "-y" ]]; then
	really=1; shift
fi

if [[ -d ~/lib/dotfiles && ! -d ~/.dotfiles ]]; then
	echo "Moving dotfiles directory"
	if (( really )); then
		mv -v ~/lib/dotfiles ~/.dotfiles
	fi
	echo
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

files=(~/.config/mutt/muttrc)

for file in "${files[@]}"; do
	if [[ ! -f "$file" ]]; then
		continue
	fi
	if ! grep -qs 'lib/dotfiles' "$file"; then
		continue
	fi
	sed='s!lib/dotfiles!.dotfiles!g'
	if (( really )); then
		echo "Updating $file"
		sed -i "$sed" "$file"
	else
		echo "OLD: $file"
		grep -n 'lib/dotfiles' "$file"
		echo "NEW: $file"
		grep -n 'lib/dotfiles' "$file" | sed "$sed"
	fi
	echo
done

if (( !really )); then
	echo "Nothing done, use -y to perform the changes that were displayed."
fi
