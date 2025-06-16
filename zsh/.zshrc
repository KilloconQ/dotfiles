# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export EDITOR="nvim"
export VISUAL="nvim"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# volta
export VOLTA_HOME="$HOME/.volta"
export BUN_INSTALL="$HOME/.bun"

export PATH="$VOLTA_HOME/bin:$BUN_INSTALL/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Historial de comandos al estilo Fish
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY

# Sugerencias rápidas con flechas
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode aUto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*" --glob "!.zsh/*"'
alias f='fzf'

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

# Comodines
alias cl='clear'
alias so='source ~/.zshrc'
alias gen='kqgen'
alias lg='lazygit'
alias v='nvim'
alias dot='z dotfiles; nvim .'
alias cat='bat'
alias zwork='zellij a work'

# Reemplazos de ls con eza
alias ls='lsd --group-dirs=first'
alias ll='lsd -lah --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias lt='lsd --tree --depth=2 --group-dirs=first'

# Npm
alias nr="npm run"
alias ni="npm install"
alias nrd="npm run dev"

#bun
alias br="bun run"
alias ba="bun add"
alias bi="bun install"
alias brd="bun run dev"

#functions

ya_zed() {
  tmp=$(mktemp -t "yazi-chooser.XXXXXXXXXX")
  yazi --chooser-file "$tmp" "$@"

  if [ -s "$tmp" ]; then
    opened_file=$(head -n 1 -- "$tmp")
    if [ -n "$opened_file" ]; then
      if [ -d "$opened_file" ]; then
        zed --add "$opened_file"
      else
        zed --add "$opened_file"
      fi
    fi
  fi
  rm -f -- "$tmp"
}

eval "$(zoxide init zsh)"
alias cd='z'

eval "$(starship init zsh)"

# Load Angular CLI autocompletion.
eval "$(ng completion script)"

# bun completions
[ -s "/home/killoconq/.bun/_bun" ] && source "/home/killoconq/.bun/_bun"

# bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
