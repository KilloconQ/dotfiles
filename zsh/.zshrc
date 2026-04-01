# ——————————————————————————————————————————————
# 1. Sistema operativo
# ——————————————————————————————————————————————
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"

# ——————————————————————————————————————————————
# 2. Entorno principal
# ——————————————————————————————————————————————
export ZSH="$HOME/.oh-my-zsh"
export BUN_INSTALL="$HOME/.bun"
export EDITOR="nvim"
export VISUAL="nvim"

# ——————————————————————————————————————————————
# 3. Homebrew (macOS y Linuxbrew)
# ——————————————————————————————————————————————
if [[ "$OS" == "darwin" ]]; then
  # macOS (Intel / Apple Silicon)
  if command -v brew >/dev/null; then
    eval "$(/usr/local/bin/brew shellenv 2>/dev/null || /opt/homebrew/bin/brew shellenv 2>/dev/null)"
  fi
else
  # Linux Brew (opcional si lo tienes)
  if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# ——————————————————————————————————————————————
# 4. PATH limpio y ordenado
# ——————————————————————————————————————————————
export FLUTTER_HOME="$HOME/dev/flutter"
export PATH="$FLUTTER_HOME/bin:$BUN_INSTALL/bin:$HOME/bin:$HOME/.local/bin:$PATH"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" == *":$PNPM_HOME:"* ]] || export PATH="$PNPM_HOME:$PATH"

# GOPATH solo si Go existe (mise lo crea)
if command -v go >/dev/null 2>&1; then
  export GOPATH="$(go env GOPATH)"
  export PATH="$GOPATH/bin:$PATH"
fi

# ——————————————————————————————————————————————
# 5. Oh My Zsh + plugins
# ——————————————————————————————————————————————
plugins=(git zsh-autosuggestions zsh-syntax-highlighting vi-mode)
source "$ZSH/oh-my-zsh.sh"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# ——————————————————————————————————————————————
# 6. Herramientas
# ——————————————————————————————————————————————
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"


# ——————————————————————————————————————————————
# 7. Historial
# ——————————————————————————————————————————————
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY

# Navegación con flechas estilo Fish
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
alias vk='NVIM_APPNAME="nvim-kickstart" nvim'
alias cat='bat'

alias zwork='zellij a work'
alias zdev='zellij a dev'
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

unalias gga

# NPM / Bun / pnpm
alias nr='npm run'
alias ni='npm install'
alias nrd='npm run dev'
alias nrdp='npm run deploy'

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

# eza
if command -v eza >/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --group-directories-first --no-time'
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
    opened_file=$(head -n 1 "$tmp")
    [[ -n "$opened_file" ]] && zed --add "$opened_file"
  fi
  rm -f "$tmp"
}

# ——————————————————————————————————————————————
# 9. OpenCode
# ——————————————————————————————————————————————
if [[ "$OS" == "darwin" ]]; then
  export PATH="$HOME/.opencode/bin:$PATH"
else
  export PATH="$HOME/.opencode/bin:$PATH"
fi

# ——————————————————————————————————————————————
# 10. Google Cloud SDK (opcional)
# ——————————————————————————————————————————————
[[ -f '/usr/local/share/google-cloud-sdk/path.zsh.inc' ]] && . '/usr/local/share/google-cloud-sdk/path.zsh.inc'
[[ -f '/usr/local/share/google-cloud-sdk/completion.zsh.inc' ]] && . '/usr/local/share/google-cloud-sdk/completion.zsh.inc'

# ——————————————————————————————————————————————
# 11. Mise (LO MÁS IMPORTANTE — ACTIVADOR)
# ——————————————————————————————————————————————
eval "$(mise activate zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/killoconq/Descargas/google-cloud-sdk/path.zsh.inc' ]; then . '/home/killoconq/Descargas/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/killoconq/Descargas/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/killoconq/Descargas/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/usr/local/opt/openjdk@21/bin:$PATH"

# Resend CLI
export PATH="$HOME/.resend/bin:$PATH"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

eval "$(fnm env --use-on-cd --shell zsh)"
# ng completions
command -v ng &>/dev/null && eval "$(ng completion script)"
