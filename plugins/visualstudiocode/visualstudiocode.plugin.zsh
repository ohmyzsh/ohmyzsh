() {
if [[ "$OSTYPE" == linux* ]]; then
    local _vsc_linux_paths
    _vsc_linux_paths=(
        "/usr/local/bin/code"
        "/opt/vscode/code"
        "/usr/bin/code"
    )
    for _vsc_path in $_vsc_linux_paths; do
        if [[ -a $_vsc_path ]]; then
            vsc_run() { $_vsc_path $@ >/dev/null 2>&1 &| }
            alias vsc=vsc_run
            break
        fi
    done
elif [[ "$OSTYPE" = darwin* ]]; then
    local _visualstudiocode_darwin_paths
    _visualstudiocode_darwin_paths=(
        "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        "/usr/local/bin/code"
    )
    for _visualstudiocode_path in $_visualstudiocode_darwin_paths; do
        if [[ -a $_visualstudiocode_path ]]; then
            visualstudiocode () { "$_visualstudiocode_path" $* }
            alias vsc=visualstudiocode
            break
        fi
    done
fi

}