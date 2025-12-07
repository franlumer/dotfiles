#!/usr/bin/env bash

DOTFILES="$PWD/dotfiles"

echo "[+] Instalando Zsh"
sudo apt install -y zsh

echo "[+] Cambiando shell por defecto a zsh"
chsh -s "$(which zsh)" || echo "⚠ Ejecuta 'chsh -s \$(which zsh)' manualmente después"

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

echo "[+] Instalando plugins: autosuggestions y syntax-highlighting"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo "[+] Creando estructura de configuración personalizada"
mkdir -p "$HOME/.zsh/modules"

echo "[+] Copiando módulos personalizados"
for file in "$DOTFILES/zsh/modules"/*; do
    if [[ ! -f "$file" ]]; then
        continue
    fi
    cp "$file" "$HOME/.zsh/modules/"
done

echo "[+] Copiando archivos de configuración básicos"
for file in "$DOTFILES/zsh/basics"/*; do
    filename="$(basename "$file")"
    
    if [[ ! -f "$file" ]]; then
        continue
    fi
    
    cp "$file" "$HOME/.zsh/$filename"
done

echo "[+] Copiando tema Powerlevel10k"
if [ -f "$DOTFILES/.p10k.zsh" ]; then
    cp "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"
fi

echo ""
echo "✓ Instalación completa"
echo "  → Configuración en: ~/.zsh/"
echo "  → Cierra sesión y vuelve a entrar para usar zsh"
