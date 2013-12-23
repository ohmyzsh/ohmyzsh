## Mercurial (Hg) integration
function hg_prompt_info() {
    HG_BRANCH=$(command hg branch 2> /dev/null | grep -v ^abort)

    if [[ -n "$HG_BRANCH" ]]; then
        echo "$ZSH_THEME_HG_PROMPT_PREFIX$HG_BRANCH$(parse_hg_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
    fi
}

function parse_hg_dirty() {
    HG_STATUS=$(command hg status 2> /dev/null | tail -n1)

    if [[ -n "$HG_STATUS" ]]; then
        echo $ZSH_THEME_GIT_PROMPT_DIRTY
    else
        echo $ZSH_THEME_GIT_PROMPT_CLEAN
    fi
}
