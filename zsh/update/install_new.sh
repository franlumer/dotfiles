#!/usr/bin/bash
set -euo pipefail

# ──────────────────────────────────────────
# Name:         install.sh
# Description:  Instalacion basica de shell zsh personalizada
# Autor:        franlumer09
# Date:         11-03-2026
# Version:      1.0
# Usage:        ./script.sh [-u] [-n] [-b]
# ──────────────────────────────────────────

# Variables

ZSH_CONFIG="$HOME/.zsh_config"
ZSH_MODULES="$ZSH_CONFIG/modules"

dependencies=(zsh git eza curl ca-certificates fonts-powerline)

opt_update=false
opt_new=false
opt_backup=false

# Functions

function usage () {
    echo "Usage: $0 [-u] [-n] [-b]"
    echo "  -u | Update local instalation"
    echo "  -n | Clean instalation"
    echo "  -b | Backup local instalation "
    exit 1
}

function install_dependencies() {
    echo "[+] Installing dependencies"

    for i in "${dependencies[@]}";
    do
        if ! command -v "$i" &>/dev/null && ! dpkg -l "$i" &>/dev/null ; then    # If not command
            if ! sudo apt install -y "$i"; then       # If cannot install
                echo "[!] Error installing '$i'" >&2  # Error msg by stderr
            fi
        fi
    done
}

function backup() { # backup
    if $opt_backup; then
        local BACKUP_DIR="${2:-$HOME/.zsh_backup_$(date +%d-%m-%Y)}"

        echo "[!] Haciendo backup de $HOME/.zsh_config -> $BACKUP_DIR"
        
        if [ ! -d "$BACKUP_DIR" ]; then
            mkdir -p "$BACKUP_DIR"
        fi

        if [ -d "$HOME/.zsh_config" ]; then
            for file in "$HOME"/.zsh_config/*; do
                if [ -d "$file" ]; then
                    cp -r "$file" "$BACKUP_DIR" 
                elif [ -f "$file" ] && [ ! -L "$file" ]; then
                    cp "$file" "$BACKUP_DIR" >&2
                fi
            done
        fi
    fi
}

function install_plugins() {
    mkdir -p "$ZSH_MODULES"
    if [ -f "$PWD/modules/plugins.zsh" ]; then
        cp "$PWD/modules/plugins.zsh" "$ZSH_MODULES/"
    fi
}

function copy_dotfiles() {
    for file in "$PWD"/modules/*.zsh; do
        if [ -f "$file" ]; then
            filename="$(basename "$file")"
            cp $file "$ZSH_CONFIG/$filename"
        fi
    done
}

function config_zsh() {
    echo "[+] Cambiando shell por defecto a zsh"
    chsh -s "$(which zsh)"

    export ZSH="$ZSH_MODULES/oh-my-zsh"
    export ZSH_CUSTOM="$ZSH/custom"
    export RUNZSH=no
    export CHSH=no

    echo "[+] Instalando Oh My Zsh"
    if [ ! -d "$ZSH" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

        if [ -d "$HOME/.oh-my-zsh" ]; then
            mv "$HOME/.oh-my-zsh" "$ZSH"
        fi

        # Eliminar el .zshrc que creó Oh My Zsh
        [ -f "$HOME/.zshrc" ] && rm "$HOME/.zshrc"
    fi

    echo "[+] Instalando Powerlevel10k"
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
    fi

    echo "[+] Instalando autosuggestions y syntax-highlighting"
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi
}

function install_basics() {
    echo "[+] Copiando archivos de configuración"
    cp "$PWD/basics/p10k.zsh" "$HOME/.p10k.zsh"
    cp "$PWD/basics/zshrc" "$ZSH_CONFIG/.zshrc"

    # Crea symlink al .zshrc en HOME
    # El .zshrc se lee si o si desde HOME asi que 
    # hace un symlink para que mantener 
    # la organizacion de los directorios

    echo "[+] Creando symlink"
    ln -sf "$ZSH_CONFIG/.zshrc" "$HOME/.zshrc"

}

# ──────────────────────────────────────────

# Flow
#  install_dependencies
#  backup_old_zshrc
#  install_plugins
#  copy_dotfiles
#  config_zsh
#  install_basics

function main() {
    [[ "$#" -eq 0 || "$#" -gt 2 ]] && usage

    while getopts ":unb" opt; do
        case "${opt}" in
            b) opt_backup=true ;;
            u) opt_update=true ;;
            n) opt_new=true ;;
            *) usage ;;
        esac
    done

    install_dependencies
    backup   
    install_plugins         
    copy_dotfiles
    config_zsh
    install_basics

}

main "$@"