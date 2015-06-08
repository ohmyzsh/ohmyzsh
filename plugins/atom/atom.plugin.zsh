local _atom_paths > /dev/null 2>&1
_atom_paths=(
    "$HOME/Applications/Atom.app"
    "/Applications/Atom.app"
)

for _atom_path in $_atom_paths; do
    if [[ -a $_atom_path ]]; then
        alias at="open -a '$_atom_path'"
        break
    fi
done

alias att='at .'
