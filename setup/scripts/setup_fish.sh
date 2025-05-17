## scripts/setup_fish.sh
if ! command -v fish &>/dev/null; then
  log_info "Instalando fish..."
  case "$PACKAGE_MANAGER" in
  apt) sudo apt install -y fish ;;
  pacman | yay) $PACKAGE_MANAGER -S --noconfirm fish ;;
  brew) brew install fish ;;
  esac
fi

FISH_CONFIG_DIR="$HOME/.config/fish"
[ -d "$FISH_CONFIG_DIR" ] && rm -rf "$FISH_CONFIG_DIR"
ln -sfn "$DOTFILES_DIR/fish" "$FISH_CONFIG_DIR"

if ! grep -q "$(which fish)" /etc/shells; then
  echo "$(which fish)" | sudo tee -a /etc/shells
fi
chsh -s "$(which fish)"
