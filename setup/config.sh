#!/bin/bash

set -euo pipefail

# Cargar funciones de logging y detección de entorno
source ./utils/logging.sh
source ./scripts/detect_env.sh

# Mantener sudo activo
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Ruta a los dotfiles
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO="https://github.com/killoconq/dotfiles"

# Clona los dotfiles si no existen
if [ ! -d "$DOTFILES_DIR" ]; then
  log_warn "No se encontró $DOTFILES_DIR"
  read -rp "¿Clonar dotfiles desde $DOTFILES_REPO? (s/n): " CLONE
  if [[ "$CLONE" =~ ^[Ss]$ ]]; then
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  else
    log_error "Abortando. Necesito los dotfiles para continuar."
    exit 1
  fi
fi

cd "$DOTFILES_DIR"

source ./scripts/install_packages.sh
source ./scripts/setup_fish.sh
source ./scripts/setup_volta.sh
source ./scripts/setup_bun.sh
source ./scripts/setup_rust.sh
source ./scripts/setup_starship.sh
source ./scripts/setup_symlinks.sh

read -rp "¿Quieres configurar WezTerm, Ghostty o ninguno? (wezterm/ghostty/ninguno): " TERMINAL_CHOICE
case "$TERMINAL_CHOICE" in
wezterm) source ./scripts/setup_wezterm.sh ;;
ghostty) source ./scripts/setup_ghostty.sh ;;
ninguno) log_info "Saltando configuración de terminal..." ;;
*) log_warn "Opción inválida. Saltando terminal..." ;;
esac

log_success "Configuración completa 🚀"
