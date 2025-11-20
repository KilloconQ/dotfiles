#!/bin/bash

log_info "Instalando GlazeWM..."

if ! command -v cargo &>/dev/null; then
  log_info "Instalando Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

GLAZE_DIR="$HOME/glazewm"

if [[ ! -d "$GLAZE_DIR" ]]; then
  git clone https://github.com/larsenwork/GlazeWM "$GLAZE_DIR"
fi

cd "$GLAZE_DIR"
cargo build --release

mkdir -p ~/.config/glazewm
cp example_config.toml ~/.config/glazewm/config.toml

log_success "GlazeWM instalado."
