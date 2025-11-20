#!/bin/bash

log_info "Instalando Ghostty..."

if command -v ghostty &>/dev/null; then
  log_info "Ghostty ya está instalado."
  exit 0
fi

case "$PACKAGE_MANAGER" in
yay)
  yay -S --noconfirm ghostty
  ;;
pacman)
  log_warn "Ghostty no está en pacman. Instalando via cargo..."
  ;;
esac

if ! command -v cargo &>/dev/null; then
  log_info "Instalando Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

cargo install ghostty
log_success "Ghostty instalado correctamente."
