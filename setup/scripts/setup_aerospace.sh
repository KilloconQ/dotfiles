#!/bin/bash

log_info "Instalando Aerospace..."

if ! command -v brew &>/dev/null; then
  log_error "Homebrew no está instalado. Abortando instalación de Aerospace."
  exit 1
fi

brew tap macos-foss/tap
brew install --cask aerospace

log_success "Aerospace instalado. No olvides dar permisos en Preferencias del Sistema → Seguridad y Privacidad."
