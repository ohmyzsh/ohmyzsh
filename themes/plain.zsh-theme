PROMPT='%n@%m %~$(check_git_prompt_info)$ %{$reset_color%}'

local return_code="%(?..%{$fg[cyan]%}%? ↵%{$reset_color%})"
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[cyan]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%})%{$fg[blue]%}"


# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string. -- Brorrowed from Soliah.zsh-theme :)
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info) ]]; then
            echo " %{$fg[cyan]%}(detached%{$fg[magenta]%}*%{$fg[cyan]%})%{$reset_color%}"
        else
            echo " $(git_prompt_info)"
        fi
    fi
}
