#!/bin/bash
set -e          # Detener el script si hay errores
set -o pipefail # Detectar errores en pipes

# ===============================
# Colores para mensajes de logging
# ===============================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# ===============================
# Mantener activo el sudo
# ===============================
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# ===============================
# Funciones generales
# ===============================

# Instalar Homebrew si no está instalado
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    log_info "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log_info "Homebrew ya está instalado."
  fi
}

# Actualizar Homebrew (update y upgrade)
update_homebrew() {
  log_info "Actualizando Homebrew..."
  brew update
  brew upgrade
}

# Crear enlace simbólico comprobando que el target exista
create_symlink() {
  local target="$1"
  local link="$2"

  if [ ! -e "$target" ]; then
    log_warn "El target '$target' no existe. No se creará el enlace en '$link'."
    return 1
  fi

  if [ -L "$link" ] || [ -e "$link" ]; then
    log_info "Eliminando '$link' para evitar conflictos..."
    rm -rf "$link"
  fi

  ln -sfn "$target" "$link"
  log_success "Enlace creado: $link -> $target"
}

# Instalar un paquete con brew si no está instalado
install_brew_package() {
  local package="$1"
  if brew ls --versions "$package" >/dev/null 2>&1; then
    log_info "El paquete '$package' ya está instalado."
  else
    log_info "Instalando paquete '$package'..."
    brew install "$package"
  fi
}

# Instalar un cask con brew si no está instalado
install_brew_cask() {
  local cask="$1"
  if brew list --cask --versions "$cask" >/dev/null 2>&1; then
    log_info "El cask '$cask' ya está instalado."
  else
    log_info "Instalando cask '$cask'..."
    brew install --cask "$cask"
  fi
}

# ===============================
# Configuración según el SO
# ===============================
setup_macos() {
  log_info "Detectado sistema operativo: macOS"
  install_homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  read -rp "¿Quieres instalar Zen Browser? (s/n): " IS_BROWSER
  if [[ "$IS_BROWSER" =~ ^[Ss]$ ]]; then
    install_brew_cask zen-browser
  fi
}

setup_linux() {
  log_info "Detectado sistema operativo: Linux"
  read -rp "¿Estás en un entorno WSL? (s/n): " IS_WSL
  if [[ "$IS_WSL" =~ ^[Ss]$ ]]; then
    WSL_PATH="/mnt/c/Users/ferna/.wezterm.lua"
    log_info "La configuración de WezTerm se enlazará a: $WSL_PATH"
  else
    LINUX_PATH="$HOME/.wezterm.lua"
    log_info "La configuración de WezTerm se enlazará a: $LINUX_PATH"
  fi

  install_homebrew
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

# ===============================
# Verificar comandos esenciales
# ===============================
if ! command -v curl &>/dev/null; then
  log_error "curl no está instalado. Por favor instálalo e intenta nuevamente."
  exit 1
fi

# ===============================
# Inicio del script según el SO
# ===============================
OS=$(uname -s)
if [ "$OS" == "Darwin" ]; then
  setup_macos
elif [ "$OS" == "Linux" ]; then
  setup_linux
else
  log_error "Sistema operativo no soportado: $OS"
  exit 1
fi

# Actualizar Homebrew antes de instalar paquetes
update_homebrew

# ===============================
# Instalar herramientas (paquetes) con Homebrew
# ===============================
# Instalar fish primero, si es que no existe
if ! command -v fish &>/dev/null; then
  log_info "Instalando fish..."
  install_brew_package fish
fi

log_info "Instalando herramientas de línea de comandos..."
packages=(git gh wget neovim fzf zellij bat lsd deno zoxide lazygit zig starship)
for pkg in "${packages[@]}"; do
  install_brew_package "$pkg"
done

# ===============================
# Configuración de fish
# ===============================
log_info "Configurando fish..."

if [ -d "$HOME/.config/fish" ]; then
  log_info "Eliminando configuración existente de fish..."
  rm -rf "$HOME/.config/fish"
fi

create_symlink "$HOME/dotfiles/fish" "$HOME/.config/fish"

# Cambiar el shell por defecto a fish
if ! grep -q "$(which fish)" /etc/shells; then
  log_info "Agregando $(which fish) a /etc/shells..."
  which fish | sudo tee -a /etc/shells
fi
chsh -s "$(which fish)"

log_info "Cargando configuración de fish..."
fish -c 'source ~/dotfiles/fish/config.fish'

# ===============================
# Instalación de Volta y Node.js
# ===============================
log_info "Instalando Volta..."
curl https://get.volta.sh | bash

if command -v node >/dev/null; then
  log_info "Node.js ya está instalado."
else
  log_info "Instalando Node.js LTS con Volta..."
  volta install node@lts
fi

fish -c 'node -v'

log_info "Instalando pnpm y typescript globalmente..."
npm install -g pnpm typescript

# ===============================
# Instalación de bun
# ===============================
log_info "Instalando bun..."
curl -fsSL https://bun.sh/install | bash

# ===============================
# Creación de enlaces simbólicos para otros dotfiles
# ===============================
log_info "Creando enlaces simbólicos para dotfiles..."
create_symlink "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
create_symlink "$HOME/dotfiles/zellij" "$HOME/.config/zellij"
create_symlink "$HOME/dotfiles/omf" "$HOME/.config/omf"
create_symlink "$HOME/dotfiles/config" "$HOME/.config/config"
create_symlink "$HOME/dotfiles/starship/starship.toml" "$HOME/.config/starship.toml"

if [ "$OS" == "Linux" ]; then
  if [[ "$IS_WSL" =~ ^[Ss]$ ]]; then
    log_info "Creando enlace para la configuración de WezTerm en WSL..."
    create_symlink "$HOME/dotfiles/wezterm/.wezterm.lua" "$WSL_PATH"
  else
    create_symlink "$HOME/dotfiles/wezterm/.wezterm.lua" "$LINUX_PATH"
  fi
else
  create_symlink "$HOME/dotfiles/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
fi

log_success "Instalación completada."
