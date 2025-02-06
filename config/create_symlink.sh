#!/bin/bash

set -e          # Detener el script si hay errores
set -o pipefail # Detectar errores en pipes

WSL_PATH="/mnt/c/Users/ferna/.wezterm.lua"

echo "Iniciando configuración del sistema..."

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
create_symlink ~/dotfiles/omf ~/.config/omf
create_symlink ~/dotfiles/config ~/.config/config
create_symlink ~/dotfiles/starship/starship.toml ~/.config/starship.toml
create_symlink ~/dotfiles/wezterm/.wezterm.lua "$WSL_PATH"

echo "Instalación completada."
