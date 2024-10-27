#!/bin/bash

# Detectar sistema operativo
OS=$(uname -s)

if [ "$OS" == "Darwin" ]; then
  echo "Sistema operativo: macOS"
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ "$OS" == "Linux" ]; then
  echo "Sistema operativo: Linux (WSL)"
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.config/fish/config.fish
fi

echo "Actualizando Homebrew..."
brew update && brew upgrade

echo "Instalando herramientas de línea de comandos..."
brew install git gh wget fish neovim fzf zellij bat lsd fnm deno

echo "Configurando fish..."

# Eliminar la configuración creada por brew si existe
if [ -d ~/.config/fish ]; then
  echo "Eliminando configuración existente de fish..."
  rm -rf ~/.config/fish
fi

# Crear el enlace simbólico hacia tu configuración de fish
ln -sfn ~/dotfiles/fish ~/.config/fish

# Cambiar el shell por defecto a fish
if ! grep -q "$(which fish)" /etc/shells; then
  which fish | sudo tee -a /etc/shells
fi
chsh -s "$(which fish)"

echo "Cargando configuración de fish..."
fish -c 'source ~/dotfiles/fish/config.fish'

echo "Verificando instalación de Oh My Fish..."
if fish -c 'type omf' &>/dev/null; then
  echo "Oh My Fish ya está instalado. Omitiendo instalación."
else
  echo "Instalando Oh My Fish..."
  echo | curl -L https://get.oh-my.fish | fish
fi

echo "Configurando fnm en fish..."
fish -c 'set -U fish_user_paths /usr/local/opt/fnm/bin $fish_user_paths'
fish -c 'fnm env | source'

echo "Gestionando instalación de Node.js LTS..."
LTS_VERSION=$(fnm ls-remote | grep -E 'v[0-9]+\.[0-9]+\.[0-9]+.*LTS' | tail -n1 | awk '{print $1}')
CURRENT_VERSION=$(fish -c 'node -v' 2>/dev/null || echo "")

if [ "$CURRENT_VERSION" != "$LTS_VERSION" ]; then
  echo "Instalando o actualizando Node.js a la versión LTS $LTS_VERSION..."
  fish -c "fnm install $LTS_VERSION && fnm use $LTS_VERSION && fnm alias default $LTS_VERSION"
else
  echo "Node.js ya está actualizado a la versión LTS $LTS_VERSION."
fi

fish -c 'node -v'
npm install -g yarn typescript

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

echo "Instalando temas y plugins de Oh My Fish..."
fish -c 'omf install pj'

echo "Instalación completada."
