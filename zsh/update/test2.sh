#!/bin/bash

function backup() { # backup <origin> <destiny>
    local BACKUP_DIR="${2:-$HOME/.zsh_backup_$(date +%d-%m-%Y)}"
    local origin="$1" #"$HOME/.zshrc"
    
    echo "[!] Haciendo backup de $("$HOME/zsh_config") -> $BACKUP_DIR" 
    
    if [ -d "$HOME/.zsh_config" ]; then
        for file in "$HOME/.zsh_config/*"; do
            if [ -d "$file" ]; then
                cp -r "$file" "$BACKUP_DIR" 
            elif [ -f "$file" ] && [! -L "$file"]; then
                cp "$file" "$BACKUP_DIR" >&2
            fi
        done
    fi

    # Backup de .zshrc existente
    if "$opt_backup"; then
        echo "[!] Haciendo backup de $(basename "$1") -> $BACKUP_DIR" 
        if ( [ -f "$origin" ] || [ -d "$origin" ] ) && [ ! -L "$origin" ]; then # file y simlink
            cp -r "$origin" "$BACKUP_DIR"
        fi
    fi
}

# backup "$HOME/.zshrc" 
# backup "$HOME/.zsh_config" "$HOME/.zshrc_backup_$(date +%Y%m%d)/.zsh_config"

backup "../install.sh" "$PWD/install_backup_$(date +%Y%m%d).sh"