# ——————————————————————————————————————————————
# 1) Sistema operativo
# ——————————————————————————————————————————————
set -gx OS (string lower (uname -s))

# ——————————————————————————————————————————————
# 2) Entorno principal
# ——————————————————————————————————————————————
set -gx VOLTA_HOME $HOME/.volta
set -gx BUN_INSTALL $HOME/.bun
set -gx EDITOR nvim
set -gx VISUAL nvim

# ——————————————————————————————————————————————
# 3) Homebrew (macOS / Linuxbrew)
# ——————————————————————————————————————————————
if test "$OS" = darwin
    if type -q brew
        eval (/usr/local/bin/brew shellenv ^/dev/null; or /opt/homebrew/bin/brew shellenv ^/dev/null)
    end
else if test "$OS" = linux
    if test -x /home/linuxbrew/.linuxbrew/bin/brew
        eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    end
end

# ——————————————————————————————————————————————
# 4) PATH (ordenado)
# ——————————————————————————————————————————————
# fish_add_path coloca al inicio del PATH si no existe
fish_add_path $VOLTA_HOME/bin
fish_add_path $BUN_INSTALL/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin

# GOPATH/bin si Go está instalado
if type -q go
    set -l GOPATH (go env GOPATH)
    if test -n "$GOPATH"
        fish_add_path $GOPATH/bin
    end
end

# Go en Linux (instalación manual)
if test "$OS" = linux
    fish_add_path /usr/local/go/bin
end

# ——————————————————————————————————————————————
# 5) Herramientas: zoxide, starship, fzf, bun, atuin
# ——————————————————————————————————————————————
status is-interactive; and begin
    # zoxide
    if type -q zoxide
        zoxide init fish | source
    end

    # starship
    if type -q starship
        starship init fish | source
    end

    # atuin
    if type -q atuin
        atuin init fish | source
    end

    # bun (PATH ya agregado arriba)
    # (En fish no es necesario sourcear _bun; basta PATH)

    # fzf (si tienes algún init específico para fish)
    if test -f ~/.fzf.fish
        source ~/.fzf.fish
    end
end

# ——————————————————————————————————————————————
# 6) Historial (fish ya comparte y persiste por defecto)
# ——————————————————————————————————————————————
# Opcional: tamaño del historial (por defecto es grande)
# set -U fish_history (nombre)   # si quieres separar historiales por perfil

# ——————————————————————————————————————————————
# 7) Keybindings: Ctrl+F => fzf, Ctrl+Z => ya_zed
# ——————————————————————————————————————————————
function fzf_widget --description 'Abrir fzf'
    command fzf
    commandline -f repaint
end

function ya_zed_widget --description 'Abrir yazi chooser y enviar a zed'
    set -l tmp (mktemp -t yazi-chooser.XXXXXXXXXX)
    yazi --chooser-file $tmp $argv
    if test -s $tmp
        set -l opened_file (head -n 1 -- $tmp)
        if test -n "$opened_file"
            zed --add "$opened_file"
        end
    end
    rm -f -- $tmp
    commandline -f repaint
end

# Reemplazan funciones por las teclas
bind \cf fzf_widget
# Sobrescribe Ctrl+Z (suspender) para lanzar ya_zed
bind \cz ya_zed_widget
# Si alguna app dentro del terminal aún captura Ctrl+Z, puedes desactivar la suspensión:
# stty susp undef

# ——————————————————————————————————————————————
# 8) Aliases / Abreviaturas
# ——————————————————————————————————————————————
# fish soporta 'alias' y 'abbr'. Usa 'alias' para comandos directos:
alias so='source ~/.config/fish/config.fish'
alias cl='clear'
alias f='fzf'
alias dot='z dotfiles; nvim .'
alias lg='lazygit'
alias v='nvim'
alias cat='bat'
alias zwork='zellij a work'
alias zlearn='zellij a learn'
# En zoxide, usa 'z' igual que en zsh:
functions -q z; or alias cd='z'   # solo si quieres reemplazar cd por z (opcional)
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

# NPM / Bun / PNPM
alias nr='npm run'
alias ni='npm install'
alias nrd='npm run dev'

alias br='bun run'
alias ba='bun add'
alias bi='bun install'
alias brd='bun run dev'
alias brt='bun run test'
alias bx='bunx'

alias pr='pnpm run'
alias pa='pnpm add'
alias pi='pnpm install'
alias prd='pnpm run dev'
alias prt='pnpm run test'
alias px='pnpm dlx'

# ——————————————————————————————————————————————
# 9) eza (reemplazo de ls) con iconos y directorios primero
# ——————————————————————————————————————————————
if type -q eza
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --no-time'  # igual a tu zsh actual
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --icons --level=2 --group-directories-first'
end
# Si prefieres tabla “mínima” sin permisos/usuario/grupo/tamaño/fecha:
# alias ll='eza -l --icons --group-directories-first --no-permissions --no-user --no-filesize --no-time --no-groups'

# ——————————————————————————————————————————————
# 10) OpenCode (rutas específicas)
# ——————————————————————————————————————————————
if test "$OS" = darwin
    fish_add_path /Users/fernandocorrales/.opencode/bin
else if test "$OS" = linux
    fish_add_path /home/killoconq/.opencode/bin
end
# Duplicado por si acaso (manteniendo compatibilidad con tu zsh)
fish_add_path /home/killoconq/.opencode/bin

# ——————————————————————————————————————————————
# 11) PNPM
# ——————————————————————————————————————————————
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path $PNPM_HOME

# ——————————————————————————————————————————————
# 12) Google Cloud SDK (si instalado)
# ——————————————————————————————————————————————
if test -f /usr/local/share/google-cloud-sdk/path.fish.inc
    source /usr/local/share/google-cloud-sdk/path.fish.inc
end
# Compleciones (si existiera el .fish)
if test -f /usr/local/share/google-cloud-sdk/completion.fish.inc
    source /usr/local/share/google-cloud-sdk/completion.fish.inc
end

# ——————————————————————————————————————————————
# 13) Angular CLI completions (opcional)
# ——————————————————————————————————————————————
# Angular no emite fish-completions nativos. Si quieres completado:
#   - Instala 'bass' (plugin para ejecutar scripts bash en fish)
#   - Luego:
# if type -q bass
#     bass "ng completion script" | source
# end
