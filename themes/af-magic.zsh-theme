# af-magic.zsh-theme
#
# Author: Andy Fleming
# URL: http://andyfleming.com/
# Repo: https://github.com/andyfleming/oh-my-zsh
# Direct Link: https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme
#
# Created on:		June 19, 2012
# Last modified on:	June 20, 2012


# test if prompt plugins are enables
# _git_prompt_info function useless as its defined in lib/git.zsh
function _virtualenv_prompt_info {
    [[ -n $(whence virtualenv_prompt_info) ]] && virtualenv_prompt_info
}

function _hg_prompt_info {
    [[ -n $(whence hg_prompt_info) ]] && hg_prompt_info
}


if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# primary prompt
PROMPT='$FG[237]------------------------------------------------------------%{$reset_color%}
$FG[032]%~\
$(git_prompt_info)$(_hg_prompt_info) \
$FG[105]%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'


# color vars
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

# right prompt
RPROMPT='$(_virtualenv_prompt_info)$my_gray%n@%m%{$reset_color%}%'

# mercurial settings
ZSH_THEME_HG_PROMPT_PREFIX="hg:‹%{$fg[red]%}"
ZSH_THEME_HG_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY="%{$fg[blue]%}› %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_HG_PROMPT_CLEAN="%{$fg[blue]%}›"

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075](branch:"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

# python virtualenv settings
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$FG[032]%}‹%{$fg[green]%}"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$FG[032]%}›"
