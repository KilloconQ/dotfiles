#!/bin/bash

if ! command -v mise &>/dev/null; then
  log_info "Instalando mise..."
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

log_info "Activando mise en el shell..."
eval "$(mise activate bash)"

log_success "mise configurado correctamente."
