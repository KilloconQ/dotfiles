#!/bin/bash

GO_VERSION="1.23.4"

if command -v go &>/dev/null; then
  log_info "Go ya está instalado."
  exit 0
fi

# En macOS lo instala brew (install_packages.sh), no hace falta el binario manual
if [[ "$OS_TYPE" == "mac" ]]; then
  log_warn "Go no encontrado en macOS — asegurate de que brew install go corrió correctamente."
  exit 0
fi

# Detectar arquitectura
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)  GO_ARCH="amd64" ;;
  aarch64) GO_ARCH="arm64" ;;
  armv7l)  GO_ARCH="armv6l" ;;
  *)
    log_error "Arquitectura $ARCH no soportada para instalación manual de Go."
    exit 1
    ;;
esac

log_info "Instalando Go $GO_VERSION ($GO_ARCH)..."
cd /tmp
wget "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -O go.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz

log_success "Go $GO_VERSION instalado."
