if status is-interactive
    # Commands to run in interactive sessions can go here
end

#Vim
alias v="nvim"

#Clear
alias cl="clear"

#Git
alias ga="git add ."
alias gc="git commit -m"
alias gs="git status"
alias gst="git stash"
alias gstp="git stash pop"
alias gsw="git switch"
alias gswc="git switch -c"
alias gb="git branch"
alias gbd="git branch -D"

set -gx PROJECT_PATHS ~/workspace ~/src
