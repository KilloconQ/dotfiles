# ~/.zshrc

# ——————————————————————————————————————————————
# 1. Entorno principal
# ——————————————————————————————————————————————

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Volta (Node, npm, yarn)
export VOLTA_HOME="$HOME/.volta"

# Bun (si lo usas)
export BUN_INSTALL="$HOME/.bun"

# Editor por defecto
export EDITOR="nvim"
export VISUAL="nvim"

# ——————————————————————————————————————————————
# 2. Homebrew (Linuxbrew o macOS)
# ——————————————————————————————————————————————
if command -v brew >/dev/null 2>&1; then
  # brew shellenv detecta su ubicación y exporta variables
  eval "$(brew shellenv)"
fi

# ——————————————————————————————————————————————
# 3. PATH: Volta primero, luego Bun, luego Go, luego resto
# ——————————————————————————————————————————————
export PATH="$VOLTA_HOME/bin:$BUN_INSTALL/bin:$(go env GOPATH)/bin:$HOME/bin:$HOME/.local/bin:$PATH"


# ——————————————————————————————————————————————
# 4. Plugins de Oh My Zsh
# ——————————————————————————————————————————————
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# ——————————————————————————————————————————————
# 5. Completions y herramientas
# ——————————————————————————————————————————————

# fzf (si lo tienes)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Zoxide (cd inteligente)
eval "$(zoxide init zsh)"

# Starship prompt
eval "$(starship init zsh)"

# Angular CLI autocompletion
eval "$(ng completion script)"

# ——————————————————————————————————————————————
# 6. Historial de comandos al estilo Fish
# ——————————————————————————————————————————————
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY

# ——————————————————————————————————————————————
# 6.1 Atuin: reemplazo de historial
# ——————————————————————————————————————————————
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# ——————————————————————————————————————————————
# 7. Búsqueda en historial con flechas
# ——————————————————————————————————————————————
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# ——————————————————————————————————————————————
# 8. Aliases y funciones personalizadas
# ——————————————————————————————————————————————

# Recarga config
alias so='source ~/.zshrc'

# Git
alias ga='git add .'
alias gb='git branch'
alias gbd='git branch -D'
alias gc='git commit -m'
alias gco='git checkout'
alias gcm='git checkout main'
alias gp='git pull origin'
alias gu='git push origin'
alias gs='git status -sb'
alias gd='git diff'
alias gst='git stash'
alias gstp='git stash pop'
alias gsw='git switch'
alias gswc='git switch -c'
alias gr='git remote'
alias gl='git log --all --graph --oneline --decorate'
alias gcl='git clone'
alias gf='git fetch'

# Navegación y utilidades
alias cl='clear'
alias f='fzf'
alias dot='z dotfiles; nvim .'
alias lg='lazygit'
alias v='nvim'
alias cat='bat'
alias zwork='zellij a work'

# Npm / Bun
alias nr="npm run"
alias ni="npm install"
alias nrd="npm run dev"
alias br="bun run"
alias ba="bun add"
alias bi="bun install"
alias brd="bun run dev"

# Función de ejemplo: ya_zed
ya_zed() {
  local tmp
  tmp=$(mktemp -t "yazi-chooser.XXXXXXXXXX")
  yazi --chooser-file "$tmp" "$@"
  if [ -s "$tmp" ]; then
    local opened_file
    opened_file=$(head -n 1 -- "$tmp")
    [ -n "$opened_file" ] && zed --add "$opened_file"
  fi
  rm -f -- "$tmp"
}

# Reemplazo de ls por lsd
alias ls='lsd --group-dirs=first'
alias ll='lsd -lah --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias lt='lsd --tree --depth=2 --group-dirs=first'

# ——————————————————————————————————————————————
# ¡Listo! Fin de ~/.zshrc
# ——————————————————————————————————————————————
