case $OSTYPE in
darwin*)
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
    ;;
cygwin)
    local _atom_path > /dev/null 2>&1

    _atom_path=${LOCALAPPDATA}/atom/bin/atom

    if [[ -a $_atom_path ]]; then
        cyg_open_atom()
        {
            if [[ -n $1 ]]; then
                ${_atom_path} `cygpath -w -a $1`
            else
                ${_atom_path}
            fi
        }

        alias at=cyg_open_atom
    fi
    ;;
linux*)
    # Alerts the user if 'atom' is not a found command.
    type atom >/dev/null 2>&1 && alias at="atom" || { echo >&2 "You have enabled the atom oh-my-zsh plugin on Linux, but atom is not a recognized command. Please make sure you have it installed before using this plugin."; }
esac
