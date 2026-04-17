#!/bin/bash

SSH_KEY_DIR="$HOME/.ssh/github"
KEY_NAME="id_ed25519"
CONFIG_FILE="$HOME/.ssh/config"

mkdir -p "$SSH_KEY_DIR"

read -p "Email for git: " email

if [[ -z "$email" ]]; then
    echo "No email"
    exit 1
fi

# Generar clave
ssh-keygen -t ed25519 -C "$email" -f "$SSH_KEY_DIR/$KEY_NAME"

echo "Copy this key to GitHub:"
cat "$SSH_KEY_DIR/$KEY_NAME.pub"

read -p "[!] Continue? [y/n]: " action

if [[ "$action" =~ ^[Yy]$ ]]; then
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY_DIR/$KEY_NAME"

    # Crear config solo si no existe entrada
    if ! grep -q "IdentityFile $SSH_KEY_DIR/$KEY_NAME" "$CONFIG_FILE" 2>/dev/null; then
        cat >> "$CONFIG_FILE" <<EOF

Host github.com
    HostName github.com
    User git
    IdentityFile $SSH_KEY_DIR/$KEY_NAME
    IdentitiesOnly yes
EOF
    fi

    # Permisos
    chmod 700 "$HOME/.ssh"
    chmod 700 "$SSH_KEY_DIR"
    chmod 600 "$SSH_KEY_DIR/$KEY_NAME"
    chmod 644 "$SSH_KEY_DIR/$KEY_NAME.pub"

    ssh -T git@github.com
fi
