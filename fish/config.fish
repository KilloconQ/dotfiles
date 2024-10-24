if status is-interactive
    # Commandalias cl clear
end

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

set -gx PROJECT_PATHS \
    ~/dev/Projects.db/ \
    ~/dev/work \
    ~/dev/projects/web/bingo \
    ~/dev/projects/web/svelte-todo-app/ \
    ~/dev/projects/web/software-almacen/ \
    ~/dev/projects/web/ecommerce-project/ \
    ~/dev/projects/mobile/financeTracker/

set -gx PATH /usr/local/bin /home/linuxbrew/.linuxbrew/bin $PATH

if test (uname) = Darwin
    # Configuración para macOS
    if test -e /usr/local/bin/brew
        eval "$(/usr/local/bin/brew shellenv)"
    end
else if test (uname -r | grep -qi "microsoft")
    # Configuración para WSL
    if test -e /home/linuxbrew/.linuxbrew/bin/brew
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    end
end

starship init fish | source
