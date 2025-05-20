#!/bin/bash

if ! command -v fish &>/dev/null; then
  log_info "Instalando fish..."
  case "$PACKAGE_MANAGER" in
  apt) sudo apt install -y fish ;;
  pacman | yay) $PACKAGE_MANAGER -S --noconfirm fish ;;
  brew) brew install fish ;;
  *) log_warn "No se pudo instalar fish automáticamente." ;;
  esac
fi

FISH_PATH="$(which fish)"
FISH_CONFIG_DIR="$HOME/.config/fish"
[ -d "$FISH_CONFIG_DIR" ] && rm -rf "$FISH_CONFIG_DIR"
ln -sfn "$DOTFILES_DIR/fish" "$FISH_CONFIG_DIR"

if ! grep -q "$FISH_PATH" /etc/shells; then
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi
chsh -s "$FISH_PATH"
