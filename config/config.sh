#!/bin/bash

set -e          # Detener el script si hay errores
set -o pipefail # Detectar errores en pipes

echo "Iniciando configuración del sistema..."

sudo -v

while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

create_symlink() {
  local target=$1
  local link=$2

  if [ -L "$link" ] || [ -d "$link" ]; then
    echo "Eliminando $link para evitar conflictos..."
    rm -rf "$link"
  fi

  ln -sfn "$target" "$link"
}

install_brew_package() {
  local package="$1"
  if brew ls --version "$package" >/dev/null; then
    echo "El paquete '$package' ya está instalado."
  else
    echo "Instalando '$package'..."
    brew install "$package"
  fi
}

install_brew_cask() {
  local cask="$1"
  if brew ls --cask --version "$cask" >/dev/null; then
    echo "El cask '$cask' ya está instalado."
  else
    echo "Instalando '$cask'..."
    brew install --cask "$cask"
  fi
}

# Detectar sistema operativo
OS=$(uname -s)

if [ "$OS" == "Darwin" ]; then
  echo "Detectado sistema operativo: macOS"
  install_homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  read -rp "¿Quieres instalar Zen Browser? (s/n): " IS_BROWSER
  if [[ "$IS_BROWSER" =~ ^[Ss]$ ]]; then
    install_brew_cask zen-browser
  fi

elif [ "$OS" == "Linux" ]; then
  echo "Detectado sistema operativo: Linux"
  read -rp "¿Estás en un entorno WSL? (s/n): " IS_WSL

  if [[ "$IS_WSL" =~ ^[Ss]$ ]]; then
    WSL_PATH="/mnt/c/Users/ferna/.wezterm.lua"
    echo "La configuración de WezTerm se enlazará a: $WSL_PATH"
  else
    LINUX_PATH="$HOME/.wezterm.lua"
    echo "La configuración de WezTerm se enlazará a: $LINUX_PATH"
  fi

  instalar_homebrew
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

else
  echo "Sistema operativo no soportado: $OS"
  exit 1
fi

if ! command -v fish &>/div/null; then
  echo "Instalando fish..."
  install_brew_package fish
fi

echo "Instalando herramientas de línea de comandos..."
install_brew_package git
install_brew_package gh
install_brew_package wget
install_brew_package fish
install_brew_package neovim
install_brew_package fzf
install_brew_package zellij
install_brew_package bat
install_brew_package lsd
install_brew_package deno
install_brew_package zoxide
install_brew_package lazygit
install_brew_package zig
install_brew_package starship

echo "Configurando fish..."

# Eliminar la configuración creada por brew si existe
if [ -d ~/.config/fish ]; then
  echo "Eliminando configuración existente de fish..."
  rm -rf ~/.config/fish
fi

# Crear el enlace simbólico hacia tu configuración de fish
create_symlink ~/dotfiles/fish ~/.config/fish

# Cambiar el shell por defecto a fish
if ! grep -q "$(which fish)" /etc/shells; then
  which fish | sudo tee -a /etc/shells
fi
chsh -s "$(which fish)"

echo "Cargando configuración de fish..."
fish -c 'source ~/dotfiles/fish/config.fish'

#Instalar volta
echo "Instalando Volta..."
curl https://get.volta.sh | bash

if command -v node >/dev/null; then
  echo "Node.js ya está instalado."
else
  echo "Gestionando instalación de Node.js LTS..."
  volta install node@lts
fi

fish -c 'node -v'
npm install -g pnpm typescript

echo "Instalando bun..."
curl -fsSL https://bun.sh/install | bash

echo "Creando enlaces simbólicos..."

create_symlink ~/dotfiles/nvim ~/.config/nvim
create_symlink ~/dotfiles/zellij ~/.config/zellij
create_symlink ~/dotfiles/omf ~/.config/omf
create_symlink ~/dotfiles/config ~/.config/config
create_symlink ~/dotfiles/starship/starship.toml ~/.config/starship.toml

if [ "$OS" == "Linux" ]; then
  if [[ "$IS_WSL" =~ ^[Yy]$ ]]; then
    create_symlink ~/dotfiles/wezterm/.wezterm.lua "$WSL_PATH"
  else
    create_symlink ~/dotfiles/wezterm/.wezterm.lua "$LINUX_PATH"
  fi
else
  create_symlink ~/dotfiles/wezterm/.wezterm.lua ~/.wezterm.lua
fi

echo "Instalación completada."
