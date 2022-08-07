PROMPT='%(?,%{$fg[green]%},%{$fg[red]%}) %{$fg[yellow]%} %% %{$reset_color%} %{$fg[blue]%} | %{$fg[cyan]%} $(date) %{$fg[blue]%} | %{$reset_color%}
%{$fg[lightgreen]%} :>'
# RPS1='%{$fg[blue]%}%~%{$reset_color%} '
RPS1='%{$fg[white]%}%2~$(git_prompt_info) %{$fg_bold[blue]%}%m%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" 🟩 "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ⚠️ %{$fg[yellow]%}"
