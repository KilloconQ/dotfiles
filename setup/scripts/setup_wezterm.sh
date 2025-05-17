### scripts/setup_wezterm.sh
if [ "$OS" == "Linux" ]; then
  if is_wsl; then
    cp "$DOTFILES_DIR/wezterm/.wezterm.lua" "/mnt/c/Users/$WINDOWS_USER/.wezterm.lua"
  else
    case "$PACKAGE_MANAGER" in
    yay | pacman) $PACKAGE_MANAGER -S --noconfirm wezterm ;;
    apt) sudo apt install -y wezterm ;;
    brew) brew install wezterm ;;
    esac
    ln -sfn "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
  fi
else
  brew install wezterm
  ln -sfn "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
fi
