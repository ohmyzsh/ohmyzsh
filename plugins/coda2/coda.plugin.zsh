# Coda 2 Alias

if  [[ $('uname') == 'Darwin' ]]; then
    local _coda_darwin_paths > /dev/null 2>&1
    _coda_darwin_paths=(
        "/usr/local/bin/coda" # if coda-cli is installed
        "/Applications/Coda 2.app"
    )

    for _coda_path in $_coda_darwin_paths; do
        if [[ -a $_coda_path ]]; then
            alias coda="'$_coda_path'"
            break
        fi
    done
fi
