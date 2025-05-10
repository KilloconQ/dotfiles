# Starship
starship init fish | source

# Zoxide
zoxide init fish | source

# fzf
# Activar bindings de fzf manualmente en Fish
if test -f /usr/share/doc/fzf/examples/key-bindings.fish
    source /usr/share/doc/fzf/examples/key-bindings.fish
end
