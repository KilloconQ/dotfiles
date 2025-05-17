OS=$(uname -s)

is_wsl() {
  grep -qi 'microsoft' /proc/version 2>/dev/null
}

detect_package_manager() {
  if command -v apt &>/dev/null; then
    echo "apt"
  elif command -v pacman &>/dev/null; then
    echo "pacman"
  elif command -v yay &>/dev/null; then
    echo "yay"
  elif command -v brew &>/dev/null; then
    echo "brew"
  else
    echo "none"
  fi
}

PACKAGE_MANAGER=$(detect_package_manager)
