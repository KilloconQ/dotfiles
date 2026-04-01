#!/bin/bash

if ! command -v fnm &>/dev/null; then
  log_info "Instalando fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
fi

log_info "Instalando Node.js LTS con fnm..."
fnm install --lts
fnm use lts-latest
fnm default lts-latest

log_info "Instalando pnpm y typescript..."
npm install -g pnpm typescript

log_success "fnm configurado correctamente."
