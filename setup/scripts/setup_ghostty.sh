### scripts/setup_ghostty.sh
if ! command -v ghostty &>/dev/null; then
  log_info "Instalando Ghostty..."
  case "$PACKAGE_MANAGER" in
  apt)
    if ! command -v cargo &>/dev/null; then
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      source "$HOME/.cargo/env"
    fi
    cargo install ghostty
    ;;
  snap) sudo snap install ghostty --classic ;;
  yay) yay -S --noconfirm ghostty ;;
  pacman) log_warn "Ghostty no está en pacman. Usa yay o cargo." ;;
  brew) brew install ghostty ;;
  *) log_error "No se puede instalar Ghostty automáticamente aquí." ;;
  esac
else
  log_info "Ghostty ya está instalado."
fi
