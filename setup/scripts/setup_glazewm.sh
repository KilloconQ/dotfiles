#!/bin/bash

log_warn "GlazeWM es una app nativa de Windows (controla la API de Windows) — no se compila ni corre dentro de WSL."
log_info "Instalalo del lado Windows con: winget install glzr-io.glazewm"
log_info "Después copiá tu config: dotfiles/glazewm/.glzr -> %USERPROFILE%\\.glzr\\ en Windows."
