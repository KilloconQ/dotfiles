# ——————————————————————————————————————————————
# 1. Sistema operativo
# ——————————————————————————————————————————————
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"

# ——————————————————————————————————————————————
# 2. Entorno principal
# ——————————————————————————————————————————————
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
# 5. Zinit + plugins
# ——————————————————————————————————————————————
# Zinit se instala solo la primera vez que abres el shell
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# Síncronos: tienen que estar antes de compinit / de los bindkey de abajo
# zsh-completions solo agrega a fpath (blockf evita que lo modifique a su manera)
zinit ice blockf
zinit light zsh-users/zsh-completions
# vi-mode de Oh My Zsh, pero solo ese archivo (sin el framework)
zinit snippet OMZP::vi-mode

# compinit con caché: regenera el dump 1 vez al día, el resto usa -C
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Diferidos (turbo): cargan justo después de mostrar el primer prompt
zinit wait lucid for \
  zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
  MichaelAquilina/zsh-you-should-use \
  olets/zsh-abbr

# Valores por defecto que antes daba Oh My Zsh
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt INTERACTIVE_COMMENTS COMPLETE_IN_WORD ALWAYS_TO_END
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY EXTENDED_HISTORY
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
bindkey '^[[Z' reverse-menu-complete      # Shift+Tab
bindkey '^[[H' beginning-of-line          # Home
bindkey '^[[F' end-of-line                # End
bindkey '^[[3~' delete-char               # Supr
bindkey '^[[1;5C' forward-word            # Ctrl+→
bindkey '^[[1;5D' backward-word           # Ctrl+←

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# ——————————————————————————————————————————————
# 6. Herramientas
# ——————————————————————————————————————————————
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"


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

if command -v bat &> /dev/null; then
    alias cat="bat --style=plain"
fi

if command -v rg &> /dev/null; then
    alias grep="rg"
fi

# Zellij
alias zwork='zellij a work'
alias zdev='zellij a dev'
alias zlearn='zellij a learn'

# Tmux
alias twork='tmux new -A -s work'
alias tdev='tmux new -A -s dev'
alias tlearn='tmux new -A -s learn'
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
export PATH="$HOME/.opencode/bin:$PATH"

# ——————————————————————————————————————————————
# 10. Google Cloud SDK (opcional)
# ——————————————————————————————————————————————
[[ -f '/usr/local/share/google-cloud-sdk/path.zsh.inc' ]] && . '/usr/local/share/google-cloud-sdk/path.zsh.inc'
[[ -f '/usr/local/share/google-cloud-sdk/completion.zsh.inc' ]] && . '/usr/local/share/google-cloud-sdk/completion.zsh.inc'

# ——————————————————————————————————————————————
# 11. Mise (LO MÁS IMPORTANTE — ACTIVADOR)
# ——————————————————————————————————————————————
eval "$(mise activate zsh)"

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

# bun completions
[ -s "/home/killoconq/.bun/_bun" ] && source "/home/killoconq/.bun/_bun"

# Pi
export PATH="/Users/fernandocorrales/.local/share/fnm/node-versions/v24.15.0/installation/bin:$PATH"
