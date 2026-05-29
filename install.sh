#!/usr/bin/bash
set -e

# ──────────────────────────────────────────
# CONFIG — editá estos valores
DOTFILES_REPO="git@github.com:franlumer/dotfiles.git"
ZSH_MODULES="$HOME/.zsh_config/modules"
ZSH_OMZ="$ZSH_MODULES/oh-my-zsh"
ZSH_CUSTOM="$ZSH_OMZ/custom"
# ──────────────────────────────────────────

echo "[+] Instalando dependencias"
sudo apt update
sudo apt install -y zsh git curl ca-certificates fonts-powerline eza

echo "[+] Clonando bare repo de dotfiles"
git clone --bare "$DOTFILES_REPO" "$HOME/.dotfiles"

# Alias temporal
dotfiles() {
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

dotfiles config --local status.showUntrackedFiles no

echo "[+] Haciendo checkout de dotfiles"
# Si hay conflictos, moverlos a backup
mkdir -p "$HOME/.dotfiles-backup"
dotfiles checkout 2>&1 | grep "^\s" | awk '{print $1}' | while read -r file; do
    mkdir -p "$HOME/.dotfiles-backup/$(dirname "$file")"
    mv "$HOME/$file" "$HOME/.dotfiles-backup/$file"
done
dotfiles checkout

echo "[+] Cambiando shell por defecto a zsh"
chsh -s "$(which zsh)"

echo "[+] Instalando Oh My Zsh"
mkdir -p "$ZSH_MODULES"
if [ ! -d "$ZSH_OMZ" ]; then
    export ZSH="$ZSH_OMZ"
    export RUNZSH=no
    export CHSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # OMZ instala en ~/.oh-my-zsh si ZSH no existe aún, moverlo
    [ -d "$HOME/.oh-my-zsh" ] && mv "$HOME/.oh-my-zsh" "$ZSH_OMZ"
fi

echo "[+] Instalando Powerlevel10k"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
fi

echo "[+] Instalando plugins de zsh"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "[+] Configurando git"
read -rp "Nombre para git: " git_name
read -rp "Email para git: " git_email
git config --global user.name "$git_name"
git config --global user.email "$git_email"

echo ""
echo "[+] Instalación completa"
echo "[+] Cerrá y volvé a abrir el terminal para aplicar los cambios"
