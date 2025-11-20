#!/bin/bash

if ! command -v bun &>/dev/null; then
  log_info "Instalando Bun..."
  curl -fsSL https://bun.sh/install | bash
else
  log_info "Bun ya está instalado."
fi
