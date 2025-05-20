#!/bin/bash

log_info "Descargando JetBrainsMono Nerd Font..."
mkdir -p ~/.local/share/fonts
wget -q -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip

cd ~/.local/share/fonts
unzip -o JetBrainsMono.zip
rm JetBrainsMono.zip

fc-cache -fv
log_success "Fuente JetBrainsMono instalada correctamente"
