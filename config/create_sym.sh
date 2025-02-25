#!/bin/bash
# Define las variables necesarias (ajusta las rutas si es necesario)
DOTFILES_DIR="$HOME/dotfiles"

# Función para crear enlaces simbólicos (similar a tu función create_symlink)
create_symlink() {
  local target="$1"
  local link="$2"

  if [ ! -e "$target" ]; then
    echo "WARN: El target '$target' no existe. No se creará el enlace en '$link'."
    return 1
  fi

  if [ -L "$link" ] || [ -e "$link" ]; then
    echo "INFO: Eliminando '$link' para evitar conflictos..."
    rm -rf "$link"
  fi

  ln -sfn "$target" "$link" && echo "SUCCESS: Enlace creado: $link -> $target" || echo "ERROR: No se pudo crear el enlace: $link -> $target"
}

# -------------------------------
# Creación de enlaces simbólicos para otros dotfiles
# -------------------------------
echo "INFO: Creando enlaces simbólicos para dotfiles..."
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/zellij" "$HOME/.config/zellij"
create_symlink "$DOTFILES_DIR/config" "$HOME/.config/config"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# -------------------------------
# Configurar Rust
# -------------------------------
echo "INFO: Configurando Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# -------------------------------
# Configuración de WezTerm
# -------------------------------
# Detectar sistema operativo
OS=$(uname -s)

if [ "$OS" = "Linux" ]; then
  # Función para detectar WSL
  is_wsl() {
    grep -qi 'microsoft' /proc/version 2>/dev/null
  }

  if is_wsl; then
    echo "INFO: Creando enlace para la configuración de WezTerm en WSL..."
    # Obtener el nombre de usuario de Windows y definir la ruta destino
    WINDOWS_USER=$(cmd.exe /c echo %USERNAME% 2>/dev/null | tr -d '\r')
    WSL_PATH="/mnt/c/Users/$WINDOWS_USER/.wezterm.lua"
    cp "$DOTFILES_DIR/wezterm/.wezterm.lua" "$WSL_PATH" && echo "SUCCESS: Copiado .wezterm.lua a $WSL_PATH"
  else
    echo "INFO: Instalando WezTerm en Linux..."
    brew install wezterm
    LINUX_PATH="$HOME/.wezterm.lua"
    create_symlink "$DOTFILES_DIR/wezterm/.wezterm.lua" "$LINUX_PATH"
  fi

else
  # Asumimos que es macOS
  echo "INFO: Instalando WezTerm en macOS..."
  brew install wezterm
  MACOS_PATH="$HOME/.wezterm.lua"
  create_symlink "$DOTFILES_DIR/wezterm/.wezterm.lua" "$MACOS_PATH"
fi

echo "SUCCESS: Instalación completada."
