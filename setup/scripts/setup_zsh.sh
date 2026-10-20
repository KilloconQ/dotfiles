#!/bin/bash

if ! command -v zsh &>/dev/null; then
  log_info "Instalando zsh..."
  case "$PACKAGE_MANAGER" in
  apt) sudo apt install -y zsh ;;
  pacman | yay) $PACKAGE_MANAGER -S --noconfirm zsh ;;
  brew) brew install zsh ;;
  *) log_warn "No se pudo instalar zsh automáticamente." ;;
  esac
fi

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
  log_info "Instalando Zinit..."
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
else
  log_info "Zinit ya está instalado."
fi

# Los plugins (autosuggestions, fast-syntax-highlighting, zsh-completions,
# you-should-use, zsh-abbr, vi-mode) los declara el .zshrc y Zinit los
# descarga solo la primera vez que abres zsh.

ZSH_PATH="$(which zsh)"

if ! grep -q "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

chsh -s "$ZSH_PATH"
log_success "Zsh configurado correctamente."
