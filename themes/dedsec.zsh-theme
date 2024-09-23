ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}on %{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}●%{$fg[green]%}%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%} "
ZSH_THEME_SVN_PROMPT_PREFIX=$ZSH_THEME_GIT_PROMPT_PREFIX
ZSH_THEME_SVN_PROMPT_SUFFIX=$ZSH_THEME_GIT_PROMPT_SUFFIX
ZSH_THEME_SVN_PROMPT_DIRTY=$ZSH_THEME_GIT_PROMPT_DIRTY
ZSH_THEME_SVN_PROMPT_CLEAN=$ZSH_THEME_GIT_PROMPT_CLEAN
ZSH_THEME_HG_PROMPT_PREFIX=$ZSH_THEME_GIT_PROMPT_PREFIX
ZSH_THEME_HG_PROMPT_SUFFIX=$ZSH_THEME_GIT_PROMPT_SUFFIX
ZSH_THEME_HG_PROMPT_DIRTY=$ZSH_THEME_GIT_PROMPT_DIRTY
ZSH_THEME_HG_PROMPT_CLEAN=$ZSH_THEME_GIT_PROMPT_CLEAN

vcs_status() {
    if [[ $(whence in_svn) != "" ]] && in_svn; then
        svn_prompt_info
    elif [[ $(whence in_hg) != "" ]] && in_hg; then
        hg_prompt_info
    else
        git_prompt_info
    fi
}

PROMPT='(%m) $fg[green]%}🢖 %1~%{$reset_color%} $(vcs_status)🢖%b '
