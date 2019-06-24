help-get-viewer() {
    if command -v mdv >/dev/null 2>&1
    then
        if [[ -z $MDV_THEME ]] && [[ -z $MDV_CODE_THEME ]]
        then export MDV_THEME=785.6556
        fi
        echo "MDV_THEME= mdv"
    elif command -v mdless >/dev/null 2>&1
    then
        echo "mdless --no-pager"
    else
        echo "No terminal Markdown viewer found." >&2
        echo "Please install 'mdless' or 'mdv'." >&2
        echo "The standard pager 'less' is used for now." >&2
        echo "less"
    fi
}

help-plugin() {
    local plugin=$1
    local viewer=$(help-get-viewer)

    if [[ -z "$plugin" ]]
    then
        echo "Please provide a plugin name to show help for."
        echo "Used plugins: ${plugins}."
        return 1
    fi

    local readme="${ZSH}/plugins/${plugin}/README.md"
    if [[ -e "$readme" ]]
    then
        eval "$viewer" "$readme" | "$PAGER"
    else
        echo "The plugin $plugin does not provide a README file."
        # TODO. Find zsh source file and cless this one.
        echo "Expected location: $readme."
        return 1
    fi
}

function _help_plugin() {
    _describe 'help-plugin' plugins
}

compdef _help_plugin help-plugin
