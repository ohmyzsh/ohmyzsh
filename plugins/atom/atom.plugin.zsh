# Gets OS Type
unamestr=$(uname -s)

# If OSX
if [[ "$unamestr" == 'Darwin' ]]; then
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
# If Linux
elif [[ "$unamestr" == 'Linux' ]]; then
    # Alerts the user if 'atom' is not a found command.
    type atom >/dev/null 2>&1 && alias at="atom" || { echo >&2 "You have enabled the atom oh-my-zsh plugin on Linux, but atom is not a recognized command. Please make sure you have it installed before using this plugin."; }
fi
