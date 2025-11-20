#!/bin/bash

log_info "Instalando OpenCode..."

if [[ ! -d "$HOME/.config/opencode" ]]; then
  curl -fsSL https://opencode.ai/install | bash
else
  log_info "OpenCode ya está instalado."
fi

CONFIG_DIR="$HOME/.config/opencode"
CONFIG_FILE="$CONFIG_DIR/config.json"

mkdir -p "$CONFIG_DIR"

cat >"$CONFIG_FILE" <<EOL
{
  "\$schema": "https://opencode.ai/config.json",
  "theme": "kanagawa",
  "model": "github-copilot/gpt-4.1",
  "autoupdate": true
}
EOL

log_success "Archivo config.json creado."
