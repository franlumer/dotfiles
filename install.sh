#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"

for file in "$DOTFILES/zsh/"*; do
	filename="$(basename "$file")"
	# Devuelve solo el nombre del archivo (quita la ruta)

	[[ "$base" == "." || "$base" == ".." ]] && continue
	# En caso de que file sea . o .. los salta

	ln -sf "$file" "$HOME/.zsh_config/$filename"
done

ln -sf "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"

unset file

echo "Dotfiles instalados correctamente."
