function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh %n@%m) "
  fi
}

PROMPT='$(ssh_connection)\
%{$FG[238]%}%3~ \
$(git_prompt_info)\
%{$fg[green]%}%(!.#.❯)\
%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$FG[237]%}(%{$FG[104]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[237]%}) %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[214]%} ✹%{$reset_color%}"

