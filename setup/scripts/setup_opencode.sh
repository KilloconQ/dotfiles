#!/bin/bash

log_info "Instalando OpenCode..."

# Verificar si OpenCode ya está instalado
if [ ! -d "$HOME/.config/opencode" ]; then
  log_info "Clonando el repositorio de OpenCode..."
  curl -fsSL https://opencode.ai/install | bash
else
  log_info "OpenCode ya está instalado."
fi

# Crear o sobrescribir el archivo config.json
CONFIG_DIR="$HOME/.config/opencode"
CONFIG_FILE="$CONFIG_DIR/config.json"

mkdir -p "$CONFIG_DIR"

cat >"$CONFIG_FILE" <<EOL
{
  "\u0024schema": "https://opencode.ai/config.json",
  "theme": "kanagawa",
  "model": "github-copilot/gpt-4.1",
  "autoupdate": true
}
EOL

log_success "Archivo config.json creado en $CONFIG_FILE"

