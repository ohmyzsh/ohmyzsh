if [[ "$OSTYPE" == "cygwin" ]]; then
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

        alias atom=cyg_open_atom
    fi
fi
