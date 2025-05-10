# Bun
set -gx BUN_INSTALL "$HOME/.bun"
set -gx PATH $BUN_INSTALL/bin $PATH

# Volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH $VOLTA_HOME/bin $PATH

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH $PNPM_HOME $PATH
end

# Deno (solo si no estás en WSL/mac)
if test "$IS_WSL" != true -a "$OS_TYPE" != Darwin
    if test -e $HOME/.deno/env.fish
        source $HOME/.deno/env.fish
    end
end

# Cargo (macOS)
if test "$OS_TYPE" = Darwin
    if test -e $HOME/.cargo/env.fish
        source $HOME/.cargo/env.fish
    end
end
