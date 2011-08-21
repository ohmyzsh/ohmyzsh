# ------------------------------------------------------------------------
#          FILE: illenseer-verbose.zsh-theme
#   DESCRIPTION: oh-my-zsh theme file, based on a lot of themes
#        AUTHOR: Nils Pascal Illenseer <ni@np.cx>
#       VERSION: 1
# ------------------------------------------------------------------------

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$reset_color%}contains"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$fg_bold[magenta]%}unmerged"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$fg_bold[red]%}deleted"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$fg_bold[yellow]%}renamed"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg_bold[yellow]%}modified"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg_bold[green]%}added"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg_bold[red]%}untracked"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg_bold[red]%}‼"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$reset_color%}- commit %{$fg_bold[white]%}[%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]"

# Return code
local ret_status="%(?::%{$fg_bold[red]%}%S↑%s%?)%{$reset_color%}"

# root (red) vs. normal user (green)
if [[ `id -u` -eq 0 ]]; then
    user="%{$fg_bold[red]%}%n%{$reset_color%}"
else
    user="%{$fg_bold[green]%}%n%{$reset_color%}"
fi

# local (white) vs. remote (gray)
if [[ -n $SSH_CONNECTION ]]; then
    loc="%{$fg_bold[black]%}%m%{$reset_color%}"
else
    loc="%{$fg_bold[white]%}%m%{$reset_color%}"
fi

function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

# Prompt format
if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    PROMPT='
${user} at ${loc} in %{$fg_bold[blue]%}$(collapse_pwd)%{$reset_color%}$(git_prompt_info)$(git_prompt_status)$(git_prompt_short_sha)%{$reset_color%}$(git_prompt_ahead)
%{$fg_bold[white]%}$(prompt_char)%{$reset_color%} '
    RPROMPT='${ret_status}'
else
    PROMPT='%n at %m in $(collapse_pwd) %# '
fi
