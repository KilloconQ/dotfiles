#!/bin/bash

if ! command -v rustc &>/dev/null; then
  log_info "Instalando Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  log_info "Rust ya está instalado."
fi
