if status is-interactive
    # Commandalias cl clear
end

alias ga 'git add .'
alias gb 'git branch'
alias gbd 'git branch -D'
alias gc 'git commit -m'
alias gpull 'git pull origin'
alias gpush 'git push origin'
alias gs 'git status'
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

starship init fish | source
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
set -x CHROME_BIN "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"

# pnpm
set -gx PNPM_HOME "/home/killoconq/.local/share/pnpm"
set -Ux PATH $PATH /usr/local/go/bin
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
