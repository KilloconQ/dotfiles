# scripts/setup_go.sh
if ! command -v go &>/dev/null; then
  GO_VERSION="1.21.4"
  log_info "Instalando Go $GO_VERSION desde binario oficial..."

  cd /tmp
  wget "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz" -O go.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go.tar.gz
  rm go.tar.gz

  log_success "Go $GO_VERSION instalado en /usr/local/go"
else
  log_info "Go ya está instalado"
fi
