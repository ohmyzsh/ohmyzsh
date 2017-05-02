if [[ -n $SSH_CONNECTION ]]; then
  export PS1="%{$fg[green]%}%n@%m:%{$reset_color%}% %3~$(git_info_for_prompt)% # "
else
  export PS1='%F{green}%3~%f$(git_prompt_info)%# '
fi

ZSH_THEME_GIT_PROMPT_PREFIX="[%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f]"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN=""
