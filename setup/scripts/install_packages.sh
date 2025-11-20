#!/bin/bash

PACKAGES=(git gh wget neovim fzf ripgrep fd zellij bat eza deno zoxide lazygit lazydocker go zig starship zsh)

for pkg in "${PACKAGES[@]}"; do
  log_info "Instalando $pkg..."
  case "$PACKAGE_MANAGER" in
  apt) sudo apt install -y "$pkg" ;;
  pacman) sudo pacman -S --noconfirm "$pkg" ;;
  yay) yay -S --noconfirm "$pkg" ;;
  brew) brew install "$pkg" ;;
  *) log_warn "Gestor de paquetes no soportado para $pkg" ;;
  esac
done
