ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[black]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%_ 
%{$fg_bold[black]%}%~%{$reset_color%}
%_⇥ '

RPROMPT='$(git_prompt_info) '

#RVM settings
if [[ -s ~/.rvm/scripts/rvm ]] ; then 
  RPROMPT="$RPROMPT %{$reset_color%}%{$fg[blue]%}\$(~/.rvm/bin/rvm-prompt i v g)%{$reset_color%}"
fi