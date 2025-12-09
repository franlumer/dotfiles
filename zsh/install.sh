#!/usr/bin/env bash

# Definir rutas base
ZSH_CONFIG="$HOME/.zsh_config"
ZSH_MODULES="$ZSH_CONFIG/modules"

mkdir -p "$ZSH_MODULES"

# Instalacion de modulos
for file in "$PWD/modules"/*; do
	filename="$(basename "$file")"

	# En caso de que no sea regular file
	if [[ ! -f "$file" ]]; then
		continue
	fi

	cp "$file" "$ZSH_MODULES/"
done

echo "[+] Instalando Zsh"
sudo apt install -y zsh

echo "[+] Cambiando shell por defecto a zsh"
chsh -s "$(which zsh)"

# Configurar rutas para Oh My Zsh en la ubicación personalizada
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

# Instalacion de archivos de configuracion básicos
echo "[+] Copiando archivos de configuración"
cp "$PWD/basics/p10k.zsh" "$HOME/.p10k.zsh"
cp "$PWD/basics/zshrc" "$ZSH_CONFIG/.zshrc"

# Copiar dotfiles personalizados (aliases, exports, ssh)
for file in "$PWD/modules"/{aliases,exports,ssh}.zsh; do
    if [ -f "$file" ]; then
        cp "$file" "$ZSH_CONFIG/"
    fi
done

# Crear symlink al zshrc en HOME
echo "[+] Creando symlink"
ln -sf "$ZSH_CONFIG/.zshrc" "$HOME/.zshrc"

echo "[+] Instalación completa"
echo "[!] Cierra y vuelve a abrir la terminal para aplicar los cambios"