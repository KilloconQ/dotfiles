#!/bin/bash

log_info "Configurando Zsh..."

# ---------------------------------------------------------
# instalar Zsh si no existe
# ---------------------------------------------------------
if ! command -v zsh &>/dev/null; then
  log_info "Instalando Zsh..."
  case "$PACKAGE_MANAGER" in
  apt) sudo apt install -y zsh ;;
  pacman) sudo pacman -S --noconfirm zsh ;;
  yay) yay -S --noconfirm zsh ;;
  brew) brew install zsh ;;
  *)
    log_warn "No se pudo instalar Zsh en este sistema."
    return 0
    ;;
  esac
else
  log_info "Zsh ya está instalado."
fi

# ---------------------------------------------------------
# Añadir Zsh a /etc/shells si no está
# ---------------------------------------------------------
ZSH_PATH="$(command -v zsh)"

if ! grep -q "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  log_info "Añadido $ZSH_PATH a /etc/shells"
fi

# ---------------------------------------------------------
# Symlink de tu .zshrc
# ---------------------------------------------------------
if [[ -f "$DOTFILES_DIR/zsh/.zshrc" ]]; then
  ln -sfn "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  log_info "Symlink .zshrc creado → $DOTFILES_DIR/zsh/.zshrc"
else
  log_warn "No se encontró $DOTFILES_DIR/zsh/.zshrc"
fi

# ---------------------------------------------------------
# Symlink de tu carpeta .config/zsh (opcional)
# ---------------------------------------------------------
if [[ -d "$DOTFILES_DIR/zsh" ]]; then
  mkdir -p "$HOME/.config"
  ln -sfn "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
  log_info "Symlink ~/.config/zsh creado"
fi

# ---------------------------------------------------------
# Plugins (Zsh plugin manager opcional)
# Si usas zinit o antibody o oh-my-zsh
# ---------------------------------------------------------
if [[ -f "$DOTFILES_DIR/zsh/plugins.sh" ]]; then
  log_info "Instalando plugins de Zsh…"
  # shellcheck disable=SC1090
  source "$DOTFILES_DIR/zsh/plugins.sh"
fi

# ---------------------------------------------------------
# Cambiar shell por defecto
# ---------------------------------------------------------
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  chsh -s "$ZSH_PATH"
  log_success "Shell cambiado a Zsh ($ZSH_PATH)"
else
  log_info "Zsh ya es tu shell por defecto."
fi

log_success "Zsh configurado correctamente."
