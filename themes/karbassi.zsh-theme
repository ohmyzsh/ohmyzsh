# ----------------------------------------------------------------------------
# FILE: karbassi.zsh-theme
# DESCRIPTION: oh-my-zsh theme file.
# AUTHOR: Ali Karbassi (ali@karbassi.com)
# VERSION: 0.1
# ----------------------------------------------------------------------------

if [ "x$OH_MY_ZSH_HG" = "x" ]; then
    OH_MY_ZSH_HG="hg"
fi

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function hg_prompt_info {
    $OH_MY_ZSH_HG prompt --angle-brackets "\
< on %{$fg[magenta]%}<branch>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

THE_TIME="%{$reset_color%}%T%{$reset_color%}"

ZSH_PROMPT_BASE_COLOR="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✘%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%} ‽%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ± %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ❯ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ⥤ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ‽ %{$reset_color%}"

ZSH_THEME_SVN_PROMPT_PREFIX=" "
ZSH_THEME_REPO_NAME_COLOR="%{$fg_bold[yellow]%}"
ZSH_THEME_SVN_REV_NR="%{$fg_bold[yellow]%}:"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%} ✘%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg[green]%} ✔%{$reset_color%}"

ZSH_THEME_SVN_PROMPT_ADDED="%{$fg[green]%} ✚%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_MODIFIED="%{$fg[blue]%} ±%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_DELETED="%{$fg[red]%} ✖%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_UNTRACKED="%{$fg[cyan]%} ‽%{$reset_color%}"


local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%}"

PROMPT='
%{$fg_bold[yellow]%}%n%{$reset_color%} at %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}
$(virtualenv_info)$ '

RPROMPT='${return_status}$(git_prompt_status)$(svn_prompt_status)$(hg_prompt_info)$(git_prompt_info)$(svn_prompt_info)%{$reset_color%}'

