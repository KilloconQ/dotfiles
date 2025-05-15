# Git
alias ga 'git add .'
alias gwa 'git worktree add'
alias gwl 'git worktree list'
alias gwr 'git worktree remove'
alias gb 'git branch'
alias gbd 'git branch -D'
alias gc 'git commit -m'
alias gp 'git pull origin'
alias gu 'git push origin'
alias gs 'git status -sb'
alias gst 'git stash'
alias gstp 'git stash pop'
alias gsw 'git switch'
alias gswc 'git switch -c'
alias gr 'git remote'
alias gl 'git log --all --graph --oneline --decorate'
alias gcl 'git clone'

# Comodines
alias v nvim
alias cl clear
alias so source
alias ll='eza -al --icons --group-directories-first'
alias lt='eza -T --icons --git-ignore'
alias cat bat
alias zwork 'zellij a work'
alias zlearn 'zellij a learn'
alias air '~/go/bin/air'
alias lg lazygit

if not type -q bat
    if type -q batcat
        alias bat='batcat'
    end
end
