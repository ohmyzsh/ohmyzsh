# ------------------------------------------------------------------------
#          FILE: illenseer.zsh-theme
#   DESCRIPTION: oh-my-zsh theme file, based on a lot of themes
#        AUTHOR: Nils Pascal Illenseer <ni@np.cx>
#       VERSION: 3
#    SCREENSHOT: http://www.flickr.com/photos/infion/6066346886/lightbox
# ------------------------------------------------------------------------

function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# disable prompt setting in virtualenv
VIRTUAL_ENV_DISABLE_PROMPT=true

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{%B%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY=" %{%b%}contains"
ZSH_THEME_GIT_PROMPT_CLEAN="%{%b%}"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$fg_bold[magenta]%}unmerged%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$fg_bold[red]%}deleted%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$fg_bold[yellow]%}renamed%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg_bold[yellow]%}modified%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg_bold[green]%}added%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg_bold[red]%}untracked%{$reset_color%}"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg_bold[red]%}‼%{$reset_color%}"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" - commit %{%B%}[%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%B%}]%{%b%}"

# Return code
local return_code="%(?::%{$fg_bold[red]%}%? ↵)%{$reset_color%}"

# root (red) vs. normal user (green)
if [ $UID -eq 0 ]; then UCOLOR="red"; else UCOLOR="green"; fi
# local (white) vs. remote (gray)
if [[ -n $SSH_CONNECTION ]]; then LCOLOR="$fg[black]"; else LCOLOR=""; fi


# Prompt format
if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    PROMPT='
%{$fg_bold[$UCOLOR]%}%n%{$reset_color%} at %{%B$LCOLOR%}%m%{%b$reset_color%} in \
%{$fg_bold[blue]%}$(collapse_pwd)%{$reset_color%}$(git_prompt_info)\
$(git_prompt_status)$(git_prompt_short_sha)$(git_prompt_ahead)
$(virtualenv_info)%{%B%}$(prompt_char)%{%b%} '
    RPROMPT='${return_code}'
else
    PROMPT='%n at %m in $(collapse_pwd) %# '
fi
