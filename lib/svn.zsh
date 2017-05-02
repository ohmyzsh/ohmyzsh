# utility functions for subversion
# based on oh-my-zsh git lib module

function svn_dirty {
    if [[ -n $(svn status) ]]; then
        echo "$ZSH_THEME_SVN_PROMPT_DIRTY"
    else
        echo "$ZSH_THEME_SVN_PROMPT_CLEAN"
    fi
}

function svn_prompt_info {
    info=$(svn info 2>/dev/null) || return
    rev=$(echo "$info" | grep Revision | sed 's/Revision: //')
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}r${rev}$(svn_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}
