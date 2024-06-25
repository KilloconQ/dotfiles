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

set -gx PROJECT_PATHS ~/workspace ~/src
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
