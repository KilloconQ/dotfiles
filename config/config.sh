#!/bin/bash

# Detectar sistema operativo
OS=$(uname -s)

if [ "$OS" == "Darwin" ]; then
  # macOS
  echo "Sistema operativo: macOS"

  # Instalar Homebrew si no está instalado
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Añadir Homebrew al PATH
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"

elif [ "$OS" == "Linux" ]; then
  # Linux (WSL)
  echo "Sistema operativo: Linux (WSL)"

  # Instalar Homebrew si no está instalado
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
  fi

  # Añadir Homebrew al PATH
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 21:00:18
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.dotfiles/fish/config.fish
fi

# Actualizar Homebrew y sus paquetes
echo "Actualizando Homebrew..."
brew update
brew upgrade

# Instalar herramientas de línea de comandos
echo "Instalando herramientas de línea de comandos..."
brew install git
brew install gh
brew install wget
brew install fish
brew install neovim
brew install fzf
brew install zellij
brew install bat
brew install lsd

# Instalar Node.js y npm
echo "Instalando Node.js y npm..."

# Obtener la versión LTS actual de Node.js desde la página oficial de Node.js
LTS_VERSION=$(curl -sL https://nodejs.org/en/ | grep -oP '(?<=LTS: Node.js )\d+\.\d+\.\d+' | head -n 1)
LTS_MAJOR_VERSION=$(echo $LTS_VERSION | cut -d. -f1)

# Verificar si brew tiene la fórmula para la versión LTS
if brew search node@$LTS_MAJOR_VERSION | grep -q "node@$LTS_MAJOR_VERSION"; then
  # Instalar la versión LTS de Node.js
  brew install node@$LTS_MAJOR_VERSION

  # Añadir la ruta de la versión LTS de Node.js al PATH para fish shell
  set -U fish_user_paths "/usr/local/opt/node@$LTS_MAJOR_VERSION/bin" $fish_user_paths
else
  echo "No se encontró la fórmula para node@$LTS_MAJOR_VERSION en Homebrew"
fi

# Verificar la instalación
fish -c 'node -v'

# Instalar paquetes de npm globalmente
echo "Instalando paquetes de npm globalmente..."
npm install -g yarn
npm install -g typescript

# Cambiar el shell por defecto a fish
echo "Cambiando el shell por defecto a fish..."
if ! grep -q "$(which fish)" /etc/shells; then
  echo "$(which fish)" | sudo tee -a /etc/shells
fi
chsh -s $(which fish)

# Crear enlaces simbólicos en ~/.config
echo "Creando enlaces simbólicos en ~/.config..."
ln -sb ~/.dotfiles/nvim ~/.config/nvim
ln -sb ~/.dotfiles/zellij ~/.config/zellij
ln -sb ~/.dotfiles/wezterm/.wezterm.lua ~/.wezterm.lua
ln -sb ~/.dotfiles/fish ~/.config/fish
ln -sb ~/.dotfiles/omf ~/.config/omf
ln -sb ~/.dotfiles/config ~/.config/config
ln -sb ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

# Instalar Oh My Fish
echo "Instalando Oh My Fish..."
curl -L https://get.oh-my.fish | fish

# Instalar bun
curl -fsSL https://bun.sh/install | bash

# Instalar Starship
brew install starship

# Instalar plugins y temas de Oh My Fish
echo "Instalando temas y plugins de Oh My Fish..."
omf install pj

# Instalar plugins de Neovim (LazyVim)
echo "Instalando plugins de Neovim..."
# Añadir aquí los comandos para instalar plugins de Neovim

echo "Instalación completada."
