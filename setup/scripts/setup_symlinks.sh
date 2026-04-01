#!/bin/bash

cd "$DOTFILES_DIR" || { log_error "No se pudo entrar a $DOTFILES_DIR"; exit 1; }

mkdir -p "$HOME/.config"

# Packages comunes a todos los sistemas
COMMON_PACKAGES=(nvim zsh fish zellij starship git wezterm opencode claude)

log_info "Aplicando stow para packages comunes..."
for pkg in "${COMMON_PACKAGES[@]}"; do
  if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
    stow --target="$HOME" --restow "$pkg" \
      && log_info "  ✓ $pkg" \
      || log_warn "  ✗ $pkg (conflicto — revisá manualmente)"
  fi
done

# macOS
if [[ "$OS_TYPE" == "mac" ]]; then
  log_info "Aplicando stow para packages macOS..."
  for pkg in aerospace ghostty; do
    stow --target="$HOME" --restow "$pkg" \
      && log_info "  ✓ $pkg" \
      || log_warn "  ✗ $pkg (conflicto — revisá manualmente)"
  done
fi

# WSL / Windows
if is_wsl; then
  log_info "Aplicando stow para packages WSL..."
  stow --target="$HOME" --restow glazewm \
    && log_info "  ✓ glazewm" \
    || log_warn "  ✗ glazewm (conflicto — revisá manualmente)"
fi

log_success "Symlinks creados con stow correctamente."
