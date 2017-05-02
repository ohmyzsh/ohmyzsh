#kporter theme
PROMPT=' %{$fg[cyan]%}┌[%{$fg_bold[white]%}%D{%m/%d %K:%M}%{$reset_color%}%{$fg[cyan]%}]%{$fg[white]%}-%{$fg[cyan]%}(%{$fg_bold[white]%}%~%{$reset_color%}%{$fg[cyan]%})$(git_prompt_info)%{$fg_bold[white]%}[$(jobs | wc -l)]%{$reset_color%}%{$fg[cyan]%}-
 └> % %{$reset_color%}'
RPROMPT='%{$fg_bold[white]%}$(acpi -b | cut -d ',' -f2 | tr -d '%')%%%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="-[%{$reset_color%}%{$fg[white]%}git://%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[cyan]%}]-"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
