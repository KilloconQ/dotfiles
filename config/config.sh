#!/bin/bash
# Opcional: activa el modo debug si se pasa -d como parámetro
DEBUG_MODE=false
while getopts ":d" opt; do
  case ${opt} in
  d)
    DEBUG_MODE=true
    ;;
  \?)
    echo "Uso: $0 [-d] (d: modo debug)"
    exit 1
    ;;
  esac
done

if [ "$DEBUG_MODE" = true ]; then
  set -x
fi

set -e
set -o pipefail

# -------------------------------
# Descripción: Automatización de la configuración del entorno de desarrollo.
# Antes de ejecutar, asegúrate de tener configurada la URL de tu repositorio de dotfiles
# si es que no lo tienes clonado en $HOME/dotfiles.
# -------------------------------

# -------------------------------
# Variables Globales
# -------------------------------
DOTFILES_DIR="$HOME/dotfiles"
# Configura aquí la URL de tu repositorio de dotfiles si deseas clonarlo automáticamente.
DOTFILES_REPO="https://github.com/tu_usuario/tus_dotfiles.git"
FISH_CONFIG_DIR="$HOME/.config/fish"

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
# Clonar dotfiles (si es necesario)
# -------------------------------
ensure_dotfiles() {
  if [ ! -d "$DOTFILES_DIR" ]; then
    log_warn "No se encontró el directorio de dotfiles en $DOTFILES_DIR."
    read -rp "¿Deseas clonar el repositorio de dotfiles desde $DOTFILES_REPO? (s/n): " CLONE_ANSWER
    if [[ "$CLONE_ANSWER" =~ ^[Ss]$ ]]; then
      git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
      log_success "Repositorio clonado en $DOTFILES_DIR."
    else
      log_error "No se encontraron dotfiles y no se clonó el repositorio. Abortando."
      exit 1
    fi
  else
    log_info "Directorio de dotfiles encontrado en $DOTFILES_DIR."
  fi
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
# Función para crear enlaces simbólicos
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

  ln -sfn "$target" "$link" && log_success "Enlace creado: $link -> $target" || log_error "No se pudo crear el enlace: $link -> $target"
}

# -------------------------------
# Configuración según el SO
# -------------------------------
setup_macos() {
  log_info "Detectado macOS."
  install_homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Ejemplo: instalar Zen Browser (opcional)
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
    WSL_PATH="$DOTFILES_DIR/wezterm/.wezterm.lua"
  else
    log_info "Entorno Linux nativo detectado."
    LINUX_PATH="$HOME/.wezterm.lua"
  fi
}

# -------------------------------
# Instalación de paquetes con brew y cask
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
# Cambiar shell por defecto a fish
# -------------------------------
set_default_shell() {
  local new_shell
  new_shell=$(which fish)
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

# Verifica que exista el directorio de dotfiles; de lo contrario, pregunta si se clona.
ensure_dotfiles

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

# -------------------------------
# Instalación y configuración de fish
# -------------------------------
if ! command -v fish &>/dev/null; then
  log_info "Instalando fish..."
  install_brew_package fish
fi

log_info "Configurando fish..."
[ -d "$FISH_CONFIG_DIR" ] && rm -rf "$FISH_CONFIG_DIR"
create_symlink "$DOTFILES_DIR/fish" "$FISH_CONFIG_DIR"
set_default_shell
# Carga la configuración de fish desde el repositorio de dotfiles
fish -c 'source ~/dotfiles/fish/config.fish'

# -------------------------------
# Instalación de herramientas adicionales
# -------------------------------
PACKAGES=(git gh wget neovim fzf zellij bat lsd deno zoxide lazygit lazydocker go zig starship)
log_info "Instalando herramientas de línea de comandos..."
for pkg in "${PACKAGES[@]}"; do
  install_brew_package "$pkg"
done

# -------------------------------
# Instalación de Volta y Node.js
# -------------------------------
log_info "Instalando Volta..."
curl -fsSL https://get.volta.sh | bash

if ! command -v node &>/dev/null; then
  log_info "Instalando Node.js LTS con Volta..."
  volta install node@lts
fi

# Verifica la versión de Node
fish -c 'node -v'

log_info "Instalando pnpm y typescript globalmente..."
npm install -g pnpm typescript

# -------------------------------
# Instalación de bun
# -------------------------------
log_info "Instalando bun..."
curl -fsSL https://bun.sh/install | bash

# -------------------------------
# Creación de enlaces simbólicos para otros dotfiles
# -------------------------------
log_info "Creando enlaces simbólicos para dotfiles..."
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/zellij" "$HOME/.config/zellij"
create_symlink "$DOTFILES_DIR/omf" "$HOME/.config/omf"
create_symlink "$DOTFILES_DIR/config" "$HOME/.config/config"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# -------------------------------
# Configuración de WezTerm
# -------------------------------
if [ "$OS" == "Linux" ]; then
  if is_wsl; then
    log_info "Creando enlace para la configuración de WezTerm en WSL..."
    create_symlink "$DOTFILES_DIR/wezterm/.wezterm.lua" "$WSL_PATH"
  else
    install_brew_package wezterm
    create_symlink "$DOTFILES_DIR/wezterm/.wezterm.lua" "$LINUX_PATH"
  fi
else
  install_brew_package wezterm
  create_symlink "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
fi

log_success "Instalación completada."
