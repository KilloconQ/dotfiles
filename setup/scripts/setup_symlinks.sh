#!/bin/bash

mkdir -p "$HOME/.config"

ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
ln -sfn "$DOTFILES_DIR/zellij" "$HOME/.config/zellij"

log_success "Symlinks de configuración creados."
