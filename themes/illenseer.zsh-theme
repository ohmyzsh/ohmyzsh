# ------------------------------------------------------------------------
#          FILE: illenseer.zsh-theme
#   DESCRIPTION: oh-my-zsh theme file, based on themes by Juan G. Hurtado,
#                Stephen Tudor, Dejan Ranisavljevic, jnrowe
#        AUTHOR: Nils Pascal Illenseer <ni@np.cx>
#       VERSION: 2
#    SCREENSHOT: http://www.flickr.com/photos/infion/5902602288/lightbox
# ------------------------------------------------------------------------

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$fg_bold[magenta]%}➜"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$fg_bold[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$fg_bold[yellow]%}➜"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg_bold[yellow]%}✹"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg_bold[green]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg_bold[red]%}✚"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg_bold[red]%}‼ "

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[white]%}[%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg[white]%}]"

# Return code
local ret_status="%(?:%{$fg_bold[green]%}✔:%{$fg_bold[red]%}✘ %s%?)"

# root (red) vs. normal user (green)
if [[ `id -u` -eq 0 ]]; then
    user="%{$fg_bold[red]%}%n"
    end="#"
else
    user="%{$fg_bold[green]%}%n"
    end="$"
fi

# local (white) vs. remote (yellow)
if [[ -n $SSH_CONNECTION ]]; then
    loc="%{$fg_bold[yellow]%}%m"
else
    loc="%m"
fi

# Prompt format
if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
PROMPT='${ret_status} ${user}%{$fg_bold[white]%}@${loc} %{$fg_bold[blue]%}%~%u
%{$fg_bold[white]%}❱%{$reset_color%} '
RPROMPT='$(git_prompt_ahead)%{$fg_bold[white]%}$(git_prompt_info)$(git_prompt_short_sha)$(git_prompt_status)%{$reset_color%}'
else
PROMPT='%n@%m: %~%u ${end} '
fi
