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

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log_info "Instalando Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log_info "Oh My Zsh ya está instalado."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  log_info "Instalando plugin zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  log_info "Instalando plugin zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

ZSH_PATH="$(which zsh)"

if ! grep -q "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

chsh -s "$ZSH_PATH"
log_success "Zsh configurado correctamente."
