# config.nu
#
# Installed by:
# version = "0.107.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.ATUIN_LOG = "error"

# Keybindings
let config = {
  keybindings: [
    {
      name: history-search
      modifier: none
      key: up
      event: { send: executehostcommand, cmd: 'atuin search --shell-up-key-binding --interactive' }
    }
  ]
}

$env.config = {
  show_banner: false
  shell_integration: {
    osc133: false
  }

  cursor_shape: {
    emacs: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
    vi_insert: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
    vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
  }

  edit_mode: vi
  buffer_editor: nvim
}

alias l = ls
alias la = ls -a
alias ll = ls -l
alias lt = ls -lt

# Herramientas generales
alias lg = lazygit
alias v = nvim
alias cat = bat
alias zwork = zellij a work
alias zlearn = zellij a learn
alias c = clear
alias gen = kqgen

# Git
alias ga = git add .
alias gb = git branch
alias gbd = git branch -D
alias gc = git commit -m
alias gco = git checkout
alias gcm = git checkout main
alias gp = git pull origin
alias gu = git push origin
alias gs = git status -sb
alias gd = git diff
alias gst = git stash
alias gstp = git stash pop
alias gsw = git switch
alias gswc = git switch -c
alias gr = git remote
alias gl = git log --all --graph --oneline --decorate
alias gcl = git clone
alias gf = git fetch

# NPM / Bun
alias nr = npm run
alias ni = npm install
alias nrd = npm run dev

alias br = bun run
alias ba = bun add
alias bi = bun install
alias brd = bun run dev
alias brt = bun run test
alias bx = bunx

alias pr = pnpm run
alias pa = pnpm add
alias pi = pnpm install
alias prd = pnpm run dev
alias prt = pnpm run test
alias px = pnpm dlx


source ~/.local/share/atuin/init.nu
source ~/.zoxide.nu
