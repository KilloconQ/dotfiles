#!/bin/bash

if ! command -v volta &>/dev/null; then
  log_info "Instalando Volta..."
  curl -fsSL https://get.volta.sh | bash
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

log_info "Instalando Node.js LTS + pnpm + typescript con Volta..."
volta install node@lts
volta install pnpm
volta install typescript

log_success "Volta configurado correctamente."
