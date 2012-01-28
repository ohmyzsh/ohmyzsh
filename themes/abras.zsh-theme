local current_path='%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}'
local rvm_prompt='%{$fg_bold[yellow]%}$(rvm-prompt)%{$reset_color%}'
local git_info='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="on %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔"

RPROMPT="%{$fg_bold[grey]%}%{$reset_color%}"

PROMPT="
${rvm_prompt} in ${current_path} ${git_info}
› "