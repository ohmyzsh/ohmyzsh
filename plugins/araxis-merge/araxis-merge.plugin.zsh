# Araxis Merge Utilities

if  [[ "$OSTYPE" = darwin* ]]; then
    local _araxis_merge_darwin_paths > /dev/null 2>&1
    _araxis_merge_darwin_paths=(
        "$HOME/Applications/Araxis Merge.app/Contents/Utilities"
        "/Applications/Araxis Merge.app/Contents/Utilities"
    )

    for _araxis_merge_path in $_araxis_merge_darwin_paths; do
        if [[ -d "$_araxis_merge_path" ]]; then
            export PATH="${_araxis_merge_path}":$PATH
            break
        fi
    done
fi
