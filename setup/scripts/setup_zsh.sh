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

clone_plugin() {
  local repo="$1"
  local name="$2"
  shift 2
  if [[ ! -d "$ZSH_CUSTOM/plugins/$name" ]]; then
    log_info "Instalando plugin $name..."
    git clone --depth=1 "$@" "https://github.com/$repo" "$ZSH_CUSTOM/plugins/$name"
  fi
}

clone_plugin "zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
clone_plugin "zdharma-continuum/fast-syntax-highlighting" "fast-syntax-highlighting"
clone_plugin "zsh-users/zsh-completions" "zsh-completions"
clone_plugin "MichaelAquilina/zsh-you-should-use" "you-should-use"
clone_plugin "olets/zsh-abbr" "zsh-abbr" --recurse-submodules

ZSH_PATH="$(which zsh)"

if ! grep -q "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

chsh -s "$ZSH_PATH"
log_success "Zsh configurado correctamente."
