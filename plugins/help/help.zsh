# Get help for Yay aliases.
help-get-viewer() {
    if command -v mdless >/dev/null 2>&1
    then
        echo mdless
    elif command -v mdv >/dev/null 2>&1
    then
        echo mdv
    else
        echo "No terminal Markdown viewer found."
        echo "Please install 'mdless' or 'mdv'."
        echo "The standard pager 'less' is used for now."
        echo less
    fi
}

help-plugin() {
    local plugin=$1
    local viewer=$(help-get-viewer)
    viewer=mdless

    if [[ -z "$plugin" ]]
    then
        echo "Please provide a plugin name to show help for."
        echo "Used plugins: ${plugins}."
        return 1
    fi

    local readme="${ZSH}/plugins/${plugin}/README.md"
    if [[ -e "$readme" ]]
    then
         "$viewer" "$readme" | less
    else
        echo "The plugin $plugin does not provide a README file."
        # TODO. Find zsh source file and cless this one.
        echo "Expected location: $readme."
        return 1
    fi
}

alias help-yay="oh-my-zsh-plugins-help archlinux"

function _help_plugin() {
    _describe 'help-plugin' plugins
}

compdef _help_plugin help-plugin
