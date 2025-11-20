#!/bin/bash

mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

log_success "Starship configurado."
