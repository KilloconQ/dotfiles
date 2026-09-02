#!/bin/bash

log_info "Instalando Ghostty..."

if command -v ghostty &>/dev/null; then
  log_info "Ghostty ya está instalado."
  exit 0
fi

case "$OS_TYPE" in
arch)
  $PACKAGE_MANAGER -S --noconfirm ghostty
  ;;
ubuntu)
  if ! sudo apt install -y ghostty 2>/dev/null; then
    log_warn "Ghostty no está en los repos de apt de esta versión de Ubuntu, instalando vía snap..."
    sudo snap install ghostty --classic
  fi
  ;;
mac)
  brew install --cask ghostty
  ;;
*)
  log_error "Sistema no soportado para instalar Ghostty."
  exit 1
  ;;
esac

log_success "Ghostty instalado correctamente."
