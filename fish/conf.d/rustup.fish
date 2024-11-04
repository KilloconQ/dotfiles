# Verifica si .cargo/env.fish existe antes de cargarlo
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end
