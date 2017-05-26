if  [[ "$OSTYPE" = darwin* ]]; then
    local _atom_darwin_paths > /dev/null 2>&1
    _atom_darwin_paths=(
        "/Applications/Atom.app"
        "$HOME/Applications/Atom.app"
    )
    for _atom_path in $_atom_darwin_paths; do
        if [[ -a $_atom_path ]]; then
            alias atom="open -a '$_atom_path'"
            break
        fi
    done
fi
