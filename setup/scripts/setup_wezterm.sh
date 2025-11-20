#!/bin/bash

log_info "Instalando Wezterm..."

WINDOWS_USER="$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')"

if [[ "$OS_TYPE" == "arch" ]]; then
  $PACKAGE_MANAGER -S --noconfirm wezterm
  ln -sfn "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
elif [[ "$OS_TYPE" == "ubuntu" ]]; then
  sudo apt install -y wezterm
  ln -sfn "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
elif is_wsl; then
  cp "$DOTFILES_DIR/wezterm/.wezterm.lua" "/mnt/c/Users/$WINDOWS_USER/.wezterm.lua"
else
  brew install wezterm
  ln -sfn "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
fi

log_success "Wezterm instalado y configurado."
