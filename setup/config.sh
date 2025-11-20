#!/bin/bash

set -euo pipefail
exec > >(tee -i setup.log)
exec 2>&1

# ---------------------------------------------------------
# LOGGING
# ---------------------------------------------------------
log_info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
log_warn() { echo -e "\033[1;33m[WARN]\033[0m $1"; }
log_error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }
log_success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }

# ---------------------------------------------------------
# DOTFILES CONFIG
# ---------------------------------------------------------
DOTFILES_REPO="https://github.com/killoconq/dotfiles"
DOTFILES_DIR="$HOME/dotfiles"

# ---------------------------------------------------------
# 🔍 DETECCIÓN DEL SISTEMA OPERATIVO
# ---------------------------------------------------------
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
else
  log_warn "/etc/os-release no encontrado, usando fallback."
  ID="unknown"
  ID_LIKE=""
fi

if [[ "$ID" == "arch" || "$ID_LIKE" =~ arch ]]; then
  OS_TYPE="arch"
elif [[ "$ID" == "ubuntu" || "$ID" == "pop" ]]; then
  OS_TYPE="ubuntu"
elif [[ "$ID" == "darwin" ]]; then
  OS_TYPE="mac"
else
  OS_TYPE="other"
fi

log_info "Sistema detectado: $OS_TYPE"

# ---------------------------------------------------------
# SUDO
# ---------------------------------------------------------
sudo -v

# ---------------------------------------------------------
# VALIDAR GIT
# ---------------------------------------------------------
if ! command -v git &>/dev/null; then
  log_error "git no está instalado. Abortando."
  exit 1
fi

# ---------------------------------------------------------
# CLONAR DOTFILES
# ---------------------------------------------------------
if [[ ! -d "$DOTFILES_DIR" ]]; then
  log_info "Clonando dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  log_info "Dotfiles ya existen, usando carpeta existente."
fi

cd "$DOTFILES_DIR"

# ---------------------------------------------------------
# SAFE SOURCE
# ---------------------------------------------------------
safe_source() {
  local script="$1"
  if [[ -f "$script" ]]; then
    log_info "Ejecutando $script"
    # shellcheck disable=SC1090
    source "$script"
  else
    log_warn "Script $script no encontrado, salteando..."
  fi
}

# ---------------------------------------------------------
# DETECTAR WSL
# ---------------------------------------------------------
is_wsl() { grep -qi 'microsoft' /proc/version 2>/dev/null; }

# ---------------------------------------------------------
# DETECTAR PACKAGE MANAGER
# ---------------------------------------------------------
detect_package_manager() {
  case "$OS_TYPE" in
  arch)
    if command -v yay &>/dev/null; then
      echo "yay"
    else
      echo "pacman"
    fi
    ;;
  ubuntu)
    if command -v brew &>/dev/null; then
      echo "brew"
    else
      echo "install_brew"
    fi
    ;;
  mac)
    echo "brew"
    ;;
  *)
    echo "none"
    ;;
  esac
}

PACKAGE_MANAGER=$(detect_package_manager)

# ---------------------------------------------------------
# INSTALAR YAY SI ES ARCH Y NO EXISTE
# ---------------------------------------------------------
if [[ "$PACKAGE_MANAGER" == "pacman" ]] && ! command -v yay &>/dev/null; then
  log_info "Instalando yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm --needed)
  PACKAGE_MANAGER="yay"
fi

# ---------------------------------------------------------
# INSTALAR HOMEBREW SI ES NECESARIO
# ---------------------------------------------------------
if [[ "$PACKAGE_MANAGER" == "install_brew" ]]; then
  log_info "Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  PACKAGE_MANAGER="brew"
elif [[ "$PACKAGE_MANAGER" == "brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null || $(brew --prefix)/bin/brew shellenv)"
fi

# ---------------------------------------------------------
# FUENTES (ARCO LÓGICO)
# ---------------------------------------------------------
if [[ "$OS_TYPE" == "arch" ]]; then
  log_info "Instalando JetBrainsMono Nerd Font desde AUR..."
  $PACKAGE_MANAGER -S --noconfirm nerd-fonts-jetbrains-mono
else
  safe_source ./scripts/setup_fonts.sh
fi

# ---------------------------------------------------------
# INSTALAR PAQUETES Y ENTORNO
# ---------------------------------------------------------
safe_source ./scripts/install_packages.sh
safe_source ./scripts/setup_fish.sh
safe_source ./scripts/setup_volta.sh
safe_source ./scripts/setup_bun.sh
safe_source ./scripts/setup_rust.sh
safe_source ./scripts/setup_go.sh
safe_source ./scripts/setup_starship.sh
safe_source ./scripts/setup_symlinks.sh
safe_source ./scripts/setup_opencode.sh

# ---------------------------------------------------------
# SELECCIÓN DE TERMINAL
# ---------------------------------------------------------
echo "¿Qué terminal querés configurar?"
select TERMINAL_CHOICE in "wezterm" "ghostty" "ninguno"; do
  case $TERMINAL_CHOICE in
  wezterm)
    safe_source ./scripts/setup_wezterm.sh
    break
    ;;
  ghostty)
    safe_source ./scripts/setup_ghostty.sh
    break
    ;;
  ninguno)
    log_info "Saltando configuración de terminal..."
    break
    ;;
  *)
    log_warn "Opción inválida."
    ;;
  esac
done

# ---------------------------------------------------------
# CONFIG MACOS / WSL
# ---------------------------------------------------------
if [[ "$OS_TYPE" == "mac" ]]; then
  echo "¿Querés instalar y configurar Aerospace?"
  select MAC_CHOICE in "sí" "no"; do
    case $MAC_CHOICE in
    sí)
      safe_source ./scripts/setup_aerospace.sh
      break
      ;;
    no)
      log_info "Saltando Aerospace..."
      break
      ;;
    *)
      log_warn "Opción inválida."
      ;;
    esac
  done
elif is_wsl; then
  echo "¿Querés instalar y configurar GlazeWM?"
  select WIN_CHOICE in "sí" "no"; do
    case $WIN_CHOICE in
    sí)
      safe_source ./scripts/setup_glazewm.sh
      break
      ;;
    no)
      log_info "Saltando GlazeWM..."
      break
      ;;
    *)
      log_warn "Opción inválida."
      ;;
    esac
  done
fi

# ---------------------------------------------------------
# FINAL
# ---------------------------------------------------------
safe_source ./scripts/final_message.sh

log_success "Setup completado correctamente 🎉"
