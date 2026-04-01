#!/bin/bash

if ! command -v claude &>/dev/null; then
  log_info "Instalando Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
  log_success "Claude Code instalado correctamente."
else
  log_info "Claude Code ya está instalado."
fi
