#!/bin/bash

# Detectar sistema operativo
OS=$(uname -s)

if [ "$OS" == "Darwin" ]; then
  echo "Sistema operativo: macOS"
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ "$OS" == "Linux" ]; then
  echo "Sistema operativo: Linux (WSL)"
  if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.config/fish/config.fish
fi

echo "Actualizando Homebrew..."
brew update && brew upgrade

echo "Instalando herramientas de línea de comandos..."
brew install git gh wget fish neovim fzf zellij bat lsd

echo "Instalando Node.js y npm..."
LTS_VERSION=$(curl -sL https://nodejs.org/en/ | grep -oP '(?<=LTS: Node.js )\d+\.\d+\.\d+' | head -n 1)
LTS_MAJOR_VERSION=$(echo "$LTS_VERSION" | cut -d. -f1)

if brew search "node@$LTS_MAJOR_VERSION" | grep -q "node@$LTS_MAJOR_VERSION"; then
  brew install "node@$LTS_MAJOR_VERSION"
  fish_user_paths="/usr/local/opt/node@$LTS_MAJOR_VERSION/bin"
  set -U fish_user_paths "$fish_user_paths" $fish_user_paths
else
  echo "No se encontró la fórmula para node@$LTS_MAJOR_VERSION en Homebrew"
fi

fish -c 'node -v'
npm install -g yarn typescript

echo "Cambiando el shell por defecto a fish..."
if ! grep -q "$(which fish)" /etc/shells; then
  which fish | sudo tee -a /etc/shells
fi
chsh -s "$(which fish)"

echo "Creando enlaces simbólicos..."
ln -sfn ~/.dotfiles/nvim ~/.config/nvim
ln -sfn ~/.dotfiles/zellij ~/.config/zellij
ln -sfn ~/.dotfiles/wezterm/.wezterm.lua ~/.wezterm.lua
ln -sfn ~/.dotfiles/fish ~/.config/fish
ln -sfn ~/.dotfiles/omf ~/.config/omf
ln -sfn ~/.dotfiles/config ~/.config/config
ln -sfn ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

echo "Instalando Oh My Fish..."
curl -L https://get.oh-my.fish | fish

echo "Instalando bun..."
curl -fsSL https://bun.sh/install | bash

echo "Instalando Starship..."
brew install starship

echo "Instalando temas y plugins de Oh My Fish..."
omf install pj

echo "Instalación completada."
