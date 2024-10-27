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
brew install git gh wget fish neovim fzf zellij bat lsd

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

# Fuente la configuración de fish
echo "Cargando configuración de fish..."
fish -c 'source ~/dotfiles/fish/config.fish'

echo "Instalando Node.js y npm..."
LTS_VERSION=$(curl -sL https://nodejs.org/en/ | grep -oP '(?<=LTS: Node.js )\d+\.\d+\.\d+' | head -n 1)
LTS_MAJOR_VERSION=$(echo "$LTS_VERSION" | cut -d. -f1)

if brew search "node@$LTS_MAJOR_VERSION" | grep -q "node@$LTS_MAJOR_VERSION"; then
  brew install "node@$LTS_MAJOR_VERSION"
  fish_user_paths="/usr/local/opt/node@$LTS_MAJOR_VERSION/bin"
  set -U fish_user_paths "$fish_user_paths" $fish_user_paths
else
  echo "No se encontró la fórmula para node@$LTS_MAJOR_VERSION en Homebrew"
fi

fish -c 'node -v'
npm install -g yarn typescript

echo "Creando enlaces simbólicos..."

# Función para crear enlaces simbólicos correctamente
create_symlink() {
  local target=$1
  local link=$2

  if [ -L "$link" ] || [ -d "$link" ]; then
    echo "Eliminando $link para evitar conflictos..."
    rm -rf "$link"
  fi

  ln -sfn "$target" "$link"
}

# Crear enlaces simbólicos sin duplicar directorios
create_symlink ~/dotfiles/nvim ~/.config/nvim
create_symlink ~/dotfiles/zellij ~/.config/zellij
create_symlink ~/dotfiles/wezterm/.wezterm.lua ~/.wezterm.lua
create_symlink ~/dotfiles/omf ~/.config/omf
create_symlink ~/dotfiles/config ~/.config/config
create_symlink ~/dotfiles/starship/starship.toml ~/.config/starship.toml

echo "Instalando Oh My Fish..."
curl -L https://get.oh-my.fish | fish

echo "Instalando bun..."
curl -fsSL https://bun.sh/install | bash

echo "Instalando Starship..."
brew install starship

echo "Instalando temas y plugins de Oh My Fish..."
fish -c 'omf install pj'

echo "Instalación completada."
