# Set main prompt
function main_prompt() {
    local icon_user="🥷"
    local icon_host="💻"
    local icon_directory="📁"
    local icon_branch="🕉️"
    local icon_end="└❯"
    local virtualenv_char="ⓔ"

    # Check if inside a virtual environment
    local virtualenv_prompt=""
    if [[ -n $VIRTUAL_ENV ]]; then
        virtualenv_prompt="%{$fg_bold[blue]%}${virtualenv_char}%{$reset_color%} "
    fi

    # Git branch information
    local git_prompt=""
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        if [ -n "$branch" ]; then
            git_prompt=" on ${icon_branch} ${branch}"
        fi
    fi

    # Set main prompt
    PS1="%{$fg_bold[green]%}┌ ${icon_user} %n @ ${icon_host} %M %{$fg_bold[cyan]%}${icon_directory} %~${virtualenv_prompt}${git_prompt}%{$reset_color%} %{%} %{$fg_bold[green]%}%{$reset_color%}%n${icon_end} "
}

# Set continuation prompt
function continuation_prompt() {
    PS2="${icon_end} "
}

# Call main_prompt function before each command
precmd_functions+=('main_prompt')

# Set continuation prompt function
_omb_theme_PROMPT_COMMAND() {
    main_prompt
    continuation_prompt
}

# Call _omb_theme_PROMPT_COMMAND function before each command
precmd_functions+=('_omb_theme_PROMPT_COMMAND')
