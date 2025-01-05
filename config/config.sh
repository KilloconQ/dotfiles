#!/bin/bash

set -e          # Detener el script si hay errores
set -o pipefail # Detectar errores en pipes

echo "Iniciando configuración del sistema..."

# Detectar sistema operativo
OS=$(uname -s)

if [ "$OS" == "Darwin" ]; then
  echo "Detectado sistema operativo: macOS"
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ "$OS" == "Linux" ]; then
  echo "Detectado sistema operativo: Linux"
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.config/fish/config.fish
else
  echo "Sistema operativo no soportado: $OS"
  exit 1
fi

echo "Actualizando e instalando Homebrew..."
brew update && brew upgrade

echo "Instalando herramientas de línea de comandos..."
brew install git gh wget fish neovim fzf zellij bat lsd deno

echo "Configurando fish..."

# Eliminar la configuración creada por brew si existe
if [ -d ~/.config/fish ]; then
  echo "Eliminando configuración existente de fish..."
  rm -rf ~/.config/fish
fi

#Instalar volta
echo "Instalando Volta..."
curl https://get.volta.sh | bash

# Crear el enlace simbólico hacia tu configuración de fish
ln -sfn ~/dotfiles/fish ~/.config/fish

# Cambiar el shell por defecto a fish
if ! grep -q "$(which fish)" /etc/shells; then
  which fish | sudo tee -a /etc/shells
fi
chsh -s "$(which fish)"

echo "Cargando configuración de fish..."
fish -c 'source ~/dotfiles/fish/config.fish'

echo "Gestionando instalación de Node.js LTS..."
volta install node@lts

fish -c 'node -v'
npm install -g pnpmtypescript

echo "Instalando Deno versión 2..."
brew install deno
fish -c 'deno upgrade --version 2.0.0'

echo "Creando enlaces simbólicos..."

create_symlink() {
  local target=$1
  local link=$2

  if [ -L "$link" ] || [ -d "$link" ]; then
    echo "Eliminando $link para evitar conflictos..."
    rm -rf "$link"
  fi

  ln -sfn "$target" "$link"
}

create_symlink ~/dotfiles/nvim ~/.config/nvim
create_symlink ~/dotfiles/zellij ~/.config/zellij
create_symlink ~/dotfiles/wezterm/.wezterm.lua ~/.wezterm.lua
create_symlink ~/dotfiles/omf ~/.config/omf
create_symlink ~/dotfiles/config ~/.config/config
create_symlink ~/dotfiles/starship/starship.toml ~/.config/starship.toml

echo "Instalando bun..."
curl -fsSL https://bun.sh/install | bash

echo "Instalando Starship..."
brew install starship

echo "Instalación completada."
