# ——————————————————————————————————————————————
# 1. Sistema operativo
# ——————————————————————————————————————————————
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"

# ——————————————————————————————————————————————
# 2. Entorno principal
# ——————————————————————————————————————————————
export ZSH="$HOME/.oh-my-zsh"
export VOLTA_HOME="$HOME/.volta"
export BUN_INSTALL="$HOME/.bun"
export EDITOR="nvim"
export VISUAL="nvim"

# ——————————————————————————————————————————————
# 3. Homebrew
# ——————————————————————————————————————————————
if [[ "$OS" == "darwin" ]]; then
  # macOS (ambos chips)
  if command -v brew >/dev/null; then
    eval "$(/usr/local/bin/brew shellenv 2>/dev/null || /opt/homebrew/bin/brew shellenv 2>/dev/null)"
  fi
elif [[ "$OS" == "linux" ]]; then
  # Linux (Pop!_OS, Arch, etc.)
  if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# ——————————————————————————————————————————————
# 4. PATH: ordenado
# ——————————————————————————————————————————————

# Rutas base primero
export PATH="$VOLTA_HOME/bin:$BUN_INSTALL/bin:$HOME/bin:$HOME/.local/bin:$PATH"

# Añadir GOPATH/bin solo si Go está instalado
if command -v go >/dev/null 2>&1; then
  export PATH="$(go env GOPATH)/bin:$PATH"
fi

# Añadir Go manual si estás en Linux (Pop!_OS, WSL, Arch)
if [[ "$OS" == "linux" ]]; then
  export PATH="/usr/local/go/bin:$PATH"
fi

# ——————————————————————————————————————————————
# 5. Plugins y herramientas
# ——————————————————————————————————————————————
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
command -v ng &>/dev/null && eval "$(ng completion script)"
[[ -f "$HOME/.atuin/bin/env" ]] && . "$HOME/.atuin/bin/env" && eval "$(atuin init zsh)"

# ——————————————————————————————————————————————
# 6. Historial tipo Fish
# ——————————————————————————————————————————————
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY

# ——————————————————————————————————————————————
# 7. Navegación en historial con flechas
# ——————————————————————————————————————————————
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# ——————————————————————————————————————————————
# 8. Aliases
# ——————————————————————————————————————————————
alias so='source ~/.zshrc'
alias c='clear'
alias f='fzf'
alias dot='z dotfiles; nvim .'
alias lg='lazygit'
alias v='nvim'
alias cat='bat'
alias zwork='zellij a work'
alias zlearn='zellij a learn'
alias cd='z'
alias gen='kqgen'

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

# NPM / Bun
alias nr='npm run'
alias ni='npm install'
alias nrd='npm run dev'

alias br='bun run'
alias ba='bun add'
alias bi='bun install'
alias brd='bun run dev'
alias brt='bun run test'
alias bx='bunx'

alias pr='pnpm run'
alias pa='pnpm add'
alias pi='pnpm install'
alias prd='pnpm run dev'
alias prt='pnpm run test'
alias px='pnpm dlx'

# Reemplazo de ls por lsd (si existe)
# if command -v lsd >/dev/null; then
#   alias ls='lsd --group-dirs=first'
#   alias ll='lsd -lah --group-dirs=first'
#   alias la='lsd -a --group-dirs=first'
#   alias lt='lsd --tree --depth=2 --group-dirs=first'
# fi

# Reemplazo de ls por eza (si existe)
if command -v eza >/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --group-directories-first --no-time '
  alias la='eza -a --icons --group-directories-first'
  alias lt='eza --tree --icons --level=2 --group-directories-first'
fi

# ya_zed
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

# ——————————————————————————————————————————————
# Fin
# ——————————————————————————————————————————————

# opencode
if [[ "$OS" == "darwin" ]]; then
  export PATH="/Users/fernandocorrales/.opencode/bin:$PATH"
elif [[ "$OS" == "linux" ]]; then
  export PATH="/home/killoconq/.opencode/bin:$PATH"
fi

# opencode
export PATH=/home/killoconq/.opencode/bin:$PATH

# pnpm
export PNPM_HOME="/home/killoconq/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/share/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/share/google-cloud-sdk/completion.zsh.inc'; fi

# bun completions
[ -s "/Users/fernandocorrales/.bun/_bun" ] && source "/Users/fernandocorrales/.bun/_bun"
