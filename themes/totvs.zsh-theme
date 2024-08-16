PROMPT=$'
%{$bg[green]%}%{$fg_bold[black]%}%D{❪%H:%M:%S❫}%{$reset_color%} %{$bg[blue]%}%{$fg_bold[white]%}❪%n@%m❫%{$reset_color%}\
%{$bg[black]%}%{$fg_bold[white]%}❪$(ZSH_K8S)❫%{$reset_color%} %{$bg[black]%}%{$fg_bold[cyan]%}❪%~❫%{$reset_color%} $(git_prompt_info)\
%{$bg[black]%}%{$fg_no_bold[magenta]%}❱❱❱%{$reset_color%}  '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$bg[black]%}%{$fg_bold[yellow]%}❪git-branch%{$reset_color%}%{$fg_bold[blue]%}(%{$fg_bold[red]%}";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}";
ZSH_THEME_GIT_PROMPT_DIRTY="%{$bg[black]%}%{$fg_bold[blue]%})%{$reset_color%}%{$bg[black]%}%{$fg_bold[yellow]%}❫🚨";
ZSH_THEME_GIT_PROMPT_CLEAN="%{$bg[black]%}%{$fg_bold[blue]%})%{$reset_color%}%{$bg[black]%}%{$fg_bold[yellow]%}❫✅";
