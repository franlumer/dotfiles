#!/bin/bash

function backup() { # backup
    local BACKUP_DIR="$HOME/.zsh_backup_$(date +%d-%m-%Y)"

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
}

backup