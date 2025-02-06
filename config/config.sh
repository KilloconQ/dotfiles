#!/bin/bash
set -e
set -o pipefail

# -------------------------------
# Colores y funciones de logging
# -------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# -------------------------------
# Manejo de errores
# -------------------------------
handle_error() {
  log_error "Error en la línea $1. Abortando..."
  exit 1
}
trap 'handle_error $LINENO' ERR

# -------------------------------
# Función para detectar WSL
# -------------------------------
is_wsl() {
  grep -qi 'microsoft' /proc/version 2>/dev/null
}

# -------------------------------
# Instalación y actualización de Homebrew
# -------------------------------
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    log_info "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log_info "Homebrew ya está instalado."
  fi
}

update_homebrew() {
  log_info "Actualizando Homebrew..."
  brew update
  brew upgrade
}

# -------------------------------
# Funciones para crear enlaces simbólicos
# -------------------------------
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

# -------------------------------
# Configuración según el SO
# -------------------------------
setup_macos() {
  log_info "Detectado macOS."
  install_homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Ejemplo: instalar Zen Browser
  read -rp "¿Quieres instalar Zen Browser? (s/n): " IS_BROWSER
  if [[ "$IS_BROWSER" =~ ^[Ss]$ ]]; then
    install_brew_cask zen-browser
  fi
}

setup_linux() {
  log_info "Detectado Linux."
  install_homebrew
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  if is_wsl; then
    log_info "Entorno WSL detectado."
    WSL_PATH="$HOME/dotfiles/wezterm/.wezterm.lua"
  else
    log_info "Entorno Linux nativo detectado."
    LINUX_PATH="$HOME/.wezterm.lua"
  fi
}

# -------------------------------
# Instalación de paquetes con brew
# -------------------------------
install_brew_package() {
  local package="$1"
  if brew ls --versions "$package" >/dev/null 2>&1; then
    log_info "El paquete '$package' ya está instalado."
  else
    log_info "Instalando paquete '$package'..."
    brew install "$package"
  fi
}

install_brew_cask() {
  local cask="$1"
  if brew list --cask --versions "$cask" >/dev/null 2>&1; then
    log_info "El cask '$cask' ya está instalado."
  else
    log_info "Instalando cask '$cask'..."
    brew install --cask "$cask"
  fi
}

# -------------------------------
# Cambiar shell por defecto
# -------------------------------
set_default_shell() {
  local new_shell="$1"
  if ! grep -q "$new_shell" /etc/shells; then
    log_info "Agregando $new_shell a /etc/shells..."
    echo "$new_shell" | sudo tee -a /etc/shells
  fi
  chsh -s "$new_shell"
  log_success "Shell por defecto cambiado a: $new_shell"
}

# -------------------------------
# Verificar comandos esenciales
# -------------------------------
if ! command -v curl &>/dev/null; then
  log_error "curl no está instalado. Por favor, instálalo e inténtalo nuevamente."
  exit 1
fi

# -------------------------------
# Inicio del script
# -------------------------------
OS=$(uname -s)
if [ "$OS" == "Darwin" ]; then
  setup_macos
elif [ "$OS" == "Linux" ]; then
  setup_linux
else
  log_error "Sistema operativo no soportado: $OS"
  exit 1
fi

update_homebrew

# Ejemplo: instalar fish y configurarlo
if ! command -v fish &>/dev/null; then
  log_info "Instalando fish..."
  install_brew_package fish
fi

log_info "Configurando fish..."
[ -d "$HOME/.config/fish" ] && rm -rf "$HOME/.config/fish"
create_symlink "$HOME/dotfiles/fish" "$HOME/.config/fish"
set_default_shell "$(which fish)"
fish -c 'source ~/dotfiles/fish/config.fish'

# (Continuar con la instalación de otras herramientas y dotfiles...)

log_success "Instalación completada."
