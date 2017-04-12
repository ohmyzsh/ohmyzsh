#
#	Available Color Options are :
#
#	red, green, blue, cyan, magenta, yellow, white, black
#
#	Reference to what stuff in the Prompt is:
#	%n = username
#	%~ = pwd
#	%m = machine name
#

# $FG[025] - dark blue
# $FG[050] - cyan
# $FG[075] - light blue
# $FG[100] - muddy yellow
# $FG[125] - strawberry
# $FG[145] - white

PROMPT='%{$BG[237]%}%{$fg[white]%} $(hostname) \
%{$BG[008]%}%{$fg[white]%} $(collapse_pwd) \
%{$BG[056]%}%{$fg[white]%}$(git_prompt_short_sha)\
%{$BG[093]%}%{$fg[white]%}$(git_prompt_info)\
%{$reset_color%}$(git_prompt_status)
%{$reset_color%}> '

ZSH_THEME_GIT_PROMPT_SHA_BEFORE="  "
ZSH_THEME_GIT_PROMPT_SHA_AFTER="  "
ZSH_THEME_GIT_PROMPT_PREFIX=" ⑀ "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$bg[yellow]%}%{$fg[black]%} ⸭ "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%} ☩ "

# RPROMPT='$(git_prompt_status) %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_ADDED="%{$BG[010]%}%{$fg[black]%} ✰ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$BG[012]%}%{$fg[black]%} ✰ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$BG[009]%}%{$fg[black]%} ✰ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$BG[011]%}%{$fg[black]%} ✰ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$BG[014]%}%{$fg[black]%} ✰ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$BG[008]%}%{$fg[black]%} ✰ %{$reset_color%}"

#
#	Convert the home directory to "~"
#	(Courtesy of Mr. Steve Losh)
#

function collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

#	✰ ✼ ✪ ✙ ♔ ♘ ☩ ★
