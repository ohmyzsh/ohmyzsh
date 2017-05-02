function proxied() {
    [[ "$(printenv LD_PRELOAD)" == "libproxychains.so.3" ]] && echo "%{$fg_bold[red]%}[PROXIED]%{$reset_color%} "
}

function gitprompt() {
    if [[ "$(git_prompt_info)" != "" ]]; then
        echo "
$(git_prompt_info)$(git_prompt_short_sha)%{$fg_bold[blue]%} % %{$reset_color%}"
    fi
}

PROMPT='$(proxied)%{$bg[blue]%}%n@%m%{$reset_color%} %{$fg_bold[green]%}%~ %{$fg_bold[blue]%}$(gitprompt)
 %{$fg_bold[white]%}%#%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}@"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg_bold[blue]%}"

