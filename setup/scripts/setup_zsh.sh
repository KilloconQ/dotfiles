#!/bin/bash

log_info "Configurando Zsh..."

# ---------------------------------------------------------
# Instalar Zsh si no existe
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
# Oh My Zsh
# ---------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log_info "Instalando Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log_info "Oh My Zsh ya está instalado."
fi

# ---------------------------------------------------------
# Plugins de Oh My Zsh
# ---------------------------------------------------------
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  log_info "Instalando zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  log_info "Instalando zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
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
