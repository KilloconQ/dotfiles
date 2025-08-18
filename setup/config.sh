#!/bin/bash

set -euo pipefail
exec > >(tee -i setup.log)
exec 2>&1

# Ruta a los dotfiles
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO="https://github.com/killoconq/dotfiles"

# Función de logging mínima
log_info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
log_warn() { echo -e "\033[1;33m[WARN]\033[0m $1"; }
log_error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }
log_success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }

# Keep-alive para sudo
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Validar git
if ! command -v git &>/dev/null; then
  log_error "git no está instalado. Abortando."
  exit 1
fi

# Clonar dotfiles si no existen
if [ ! -d "$DOTFILES_DIR" ]; then
  log_warn "No se encontró $DOTFILES_DIR"
  read -rp "¿Clonar dotfiles desde $DOTFILES_REPO? (s/n): " CLONE
  if [[ "$CLONE" =~ ^[Ss]$ ]]; then
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  else
    log_error "Abortando. Necesito los dotfiles para continuar."
    exit 1
  fi
fi

cd "$DOTFILES_DIR"

# Función para hacer source seguro
safe_source() {
  local script="$1"
  if [ -f "$script" ]; then
    log_info "Ejecutando $script"
    source "$script"
  else
    log_warn "Script $script no encontrado, salteando..."
  fi
}

# Detección de sistema operativo
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
is_wsl() { grep -qi 'microsoft' /proc/version 2>/dev/null; }

detect_package_manager() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "brew"
  elif grep -qi 'arch\|manjaro' /etc/os-release 2>/dev/null; then
    if command -v yay &>/dev/null; then
      echo "yay"
    else
      echo "pacman"
    fi
  elif grep -qi 'ubuntu\|pop' /etc/os-release 2>/dev/null; then
    if command -v brew &>/dev/null; then
      echo "brew"
    else
      echo "install_brew"
    fi
  else
    echo "none"
  fi
}

PACKAGE_MANAGER=$(detect_package_manager)

# Instalar yay si estás en Arch y no está
if [[ "$PACKAGE_MANAGER" == "pacman" ]] && ! command -v yay &>/dev/null; then
  log_info "Instalando yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  PACKAGE_MANAGER="yay"
fi

# Instalar Homebrew si corresponde
if [[ "$PACKAGE_MANAGER" == "install_brew" ]]; then
  log_info "Instalando Homebrew en distro no-rolling (Ubuntu, Pop...)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  PACKAGE_MANAGER="brew"
elif [[ "$PACKAGE_MANAGER" == "brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null || $(brew --prefix)/bin/brew shellenv)"
fi

# Correr scripts principales
safe_source ./scripts/setup_fonts.sh
safe_source ./scripts/install_packages.sh # incluye definición de PACKAGES y su instalación
safe_source ./scripts/setup_fish.sh       # incluye validaciones, instalación, configuración y enlaces
safe_source ./scripts/setup_volta.sh
safe_source ./scripts/setup_bun.sh
safe_source ./scripts/setup_rust.sh
safe_source ./scripts/setup_go.sh
safe_source ./scripts/setup_starship.sh
safe_source ./scripts/setup_symlinks.sh
safe_source ./scripts/setup_opencode.sh

# Opción para terminal
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
  *) log_warn "Opción inválida." ;;
  esac
done

# Configuración específica por sistema operativo
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "¿Querés instalar y configurar Aerospace para macOS?"
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
    *) log_warn "Opción inválida." ;;
    esac
  done
elif is_wsl || [[ "$OS" == "Windows_NT" ]]; then
  echo "¿Querés instalar y configurar GlazeWM para Windows?"
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
    *) log_warn "Opción inválida." ;;
    esac
  done
fi
# Mensaje final modularizado
safe_source ./scripts/final_message.sh
