set OS_TYPE (uname)
set IS_WSL (uname -r | grep -qi "microsoft"; and echo "true" or echo "false")

# Aliases
alias ga 'git add .'
alias gwa 'git worktree add'
alias gwl 'git worktree list'
alias gwr 'git worktree remove'
alias gb 'git branch'
alias gbd 'git branch -D'
alias gc 'git commit -m'
alias gpull 'git pull origin'
alias gpush 'git push origin'
alias gs 'git status -sb'
alias gst 'git stash'
alias gstp 'git stash pop'
alias gsw 'git switch'
alias gswc 'git switch -c'
alias v nvim
alias cl clear
alias so source
alias ll 'lsd -l'
alias cat bat
alias zwork 'zellij a work'
alias zlearn 'zellij a learn'
alias air '~/go/bin/air'
alias lg lazygit

# General PATH
set -gx PATH /usr/local/bin /home/linuxbrew/.linuxbrew/bin $PATH

# Configuración específica de sistema
if test $OS_TYPE = Darwin
    # Configuración para macOS
    function fish_clipbaord_paste
        set text (pbpaste)
        commandline -i $text
    end
    if test -e /usr/local/bin/brew
        eval "$(/usr/local/bin/brew shellenv)"
    end
    if test -e $HOME/.cargo/env.fish
        source $HOME/.cargo/env.fish
    end
else if test $IS_WSL = true
    # Configuración para WSL
    function fish_clipboard_paste
        set text (xclip -o -selection clipboard)
        commandline -i $text
    end
    if test -e /home/linuxbrew/.linuxbrew/bin/brew
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    end
else
    # Configuración para otros sistemas Unix/Linux
    if test -e $HOME/.deno/env.fish
        source $HOME/.deno/env.fish
    end
end

# Starship prompt
starship init fish | source

# bun configuration
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# Set up fzf key bindings
fzf --fish | source

# Zoxide prompt
zoxide init fish | source
