# 
# Z ZSH Theme
# 

if [ $UID -eq 0 ]; then 
  PROMPT='%{$fg_bold[red]%}zsh%#%n@%m %{$fg_bold[blue]%}%9~ $(git_prompt_info)
% '
  RPROMPT='%{$fg[white]%}%*%F{228}'
else
  PROMPT='%{$fg[green]%}zsh%#%n@%m %{$fg_bold[blue]%}%9~ $(git_prompt_info)
% '
  RPROMPT='%{$fg[white]%}%*%F{208}'
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[white]%}git:%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[green]%}"

ZSH_THEME_SVN_PROMPT_PREFIX="%{$reset_color%}%{$fg[white]%}svn:%{$fg_bold[white]%}/"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$fg_bold[green]%}"

preexec(){
echo -ne "\e[0m"
}
