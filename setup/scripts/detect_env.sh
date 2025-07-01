OS=$(uname -s)

is_wsl() {
  grep -qi 'microsoft' /proc/version 2>/dev/null
}

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
      log_warn "Usar brew en distros no rolling (Ubuntu, Pop). Instalando si es necesario..."
      echo "install_brew"
    fi
  else
    echo "none"
  fi
}

PACKAGE_MANAGER=$(detect_package_manager)
