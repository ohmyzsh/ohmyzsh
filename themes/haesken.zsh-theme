# https://github.com/haesken
#
# Modified from the Blinks theme, with some code from Steve Losh's site.
# https://github.com/blinks zsh theme
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '%{%F{blue}%}±%{%f%k%b%}' && return
    hg root >/dev/null 2>/dev/null && echo '%{%F{blue}%}☿%{%f%k%b%}' && return
    echo '%{%F{blue}%}○%{%f%k%b%}'
}

# Show mercurial branches/status like git.
# Requires the hg extension "hg-prompt"
# http://stevelosh.com/projects/hg-prompt/
function hg_prompt_info {
    hg prompt --angle-brackets " [\
%{%B%F{blue}%}<branch>%{$reset_color%}\
%{%F{red}%}<status|modified|unknown><update>%{$reset_color%}]" 2>/dev/null
}

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$reset_color%}[%{%B%F{blue}%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}%{%F{red}%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# %                - the escape character
# %{%f%k%b%}       - resets coloring/bolding
# %{$reset_color%} - resets coloring/bolding
# %{%F{COLOR}%}    - sets a color
# %{%B%F{COLOR}%}  - sets a bold color (solarized uses some of these for grays)

# %n               - user
# @                - literal @
# %m               - short hostname
# %~               - path (truncated when in home dir)
# git_prompt_info  - branch/status of the current git repo
# hg_prompt_info   - branch/status of the current mercurial repo
# prompt_char      - if you are in a git/hg repo
# %E               - clear till end of line
# %#               - % if user, # if root

PROMPT='%{$reset_color%}
%{%F{yellow}%}%n%{$reset_color%}\
%{%F{gray}%}@%{$reset_color%}\
%{%F{blue}%}%m%{$reset_color%} \
%{%F{yellow}%}%~%{$reset_color%}\
$(git_prompt_info)%{$reset_color%}\
$(hg_prompt_info)%{$reset_color%}%E
$(prompt_char) %#%{$reset_color%} '
