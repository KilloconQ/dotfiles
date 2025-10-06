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
  table: {
    mode: "rounded"
  }

  color_config: {
    separator: "#727169"
    leading_trailing_space_bg: { attr: "n" }
    header: "#957FB8"
    date: "#7E9CD8"
    filesize: "#E6C384"
    row_index: "#C34043"
    bool: "#98BB6C"
    int: "#DCA561"
    duration: "#7FB4CA"
    range: "#A3D4D5"
    float: "#E6C384"
    string: "#DCD7BA"
    nothing: "#727169"
    binary: "#7AA89F"
    cellpath: "#FFA066"
    record: "#FF9E3B"
    list: "#7E9CD8"
    block: "#98BB6C"
    hints: "#54546D"

    shape_garbage: { fg: "#C34043" attr: "b" }
    shape_bool: { fg: "#98BB6C" attr: "b" }
    shape_int: { fg: "#DCA561" attr: "b" }
    shape_float: { fg: "#E6C384" attr: "b" }
    shape_range: { fg: "#7FB4CA" attr: "b" }
    shape_string: { fg: "#DCD7BA" attr: "b" }
    shape_record: { fg: "#957FB8" attr: "b" }
    shape_list: { fg: "#7E9CD8" attr: "b" }
    shape_block: { fg: "#98BB6C" attr: "b" }
    shape_path: { fg: "#FFA066" attr: "b" }
    shape_glob: { fg: "#7AA89F" attr: "b" }
    shape_variable: { fg: "#FF9E3B" attr: "b" }
    shape_operator: { fg: "#FFA066" attr: "b" }
    shape_external: { fg: "#7E9CD8" attr: "b" }
    shape_externalarg: { fg: "#DCD7BA" attr: "b" }
    shape_keyword: { fg: "#E6C384" attr: "b" }
  }
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
