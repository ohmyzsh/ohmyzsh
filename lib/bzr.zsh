## Bazaar integration
## Just works with the GIT integration. Add $(bzr_prompt_info) to the PROMPT
function bzr_prompt_info() {
    local bzr_branch
    bzr_branch=$(bzr nick 2>/dev/null) || return

    if [[ -n "$bzr_branch" ]]; then
        local bzr_dirty=""
        if [[ -n $(bzr status 2>/dev/null) ]]; then
            bzr_dirty=" %{$fg[red]%}*%{$reset_color%}"
        fi
        printf "%s%s%s%s" "$ZSH_THEME_SCM_PROMPT_PREFIX" "bzr::${bzr_branch##*:}" "$bzr_dirty" "$ZSH_THEME_GIT_PROMPT_SUFFIX"
    fi
}
