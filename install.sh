#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"

for file in "$DOTFILES/zsh/modules"*; do
	filename="$(basename "$file")"
	# Devuelve solo el nombre del archivo (quita la ruta)

	[[ "$base" == "." || "$base" == ".." ]] && continue
	# En caso de que file sea . o .. los salta

	ln -sf "$file" "$HOME/.zsh_config/$filename"
done

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"

unset file

echo "Dotfiles instalados correctamente."

#______________________________________________________________ REVISAR

set -e

echo "[+] Instalando Zsh"
sudo apt install -y zsh git curl

echo "[+] Cambiando shell por defecto a zsh"
chsh -s "$(which zsh)"

echo "[+] Instalando Oh My Zsh"
export RUNZSH=no
export CHSH=no
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "[+] Instalando Powerlevel10k"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
      ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

echo "[+] Instalando autosuggestions y syntax-highlighting"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

echo "[+] Instalación completa"

