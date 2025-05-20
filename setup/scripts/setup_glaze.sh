#!/bin/bash

log_info "Instalando GlazeWM..."

GLAZE_DIR="$HOME/glazewm"
if [ ! -d "$GLAZE_DIR" ]; then
  git clone https://github.com/larsenwork/GlazeWM "$GLAZE_DIR"
  cd "$GLAZE_DIR"
  cargo build --release
  mkdir -p ~/.config/glazewm
  cp example_config.toml ~/.config/glazewm/config.toml
else
  log_info "GlazeWM ya está clonado en $GLAZE_DIR"
fi

log_success "GlazeWM compilado e instalado. Configuración copiada a ~/.config/glazewm"
