local lambda='%{$fg[yellow]%}λ%{$reset_color%}'
local rvm_ruby='%{$fg[red]%}$(rvm-prompt i v g)%{$reset_color%}'
local git_branch='%{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%}'

PROMPT="%{$fg[green]%}%~ ${rvm_ruby} ${git_branch}
${lambda} "

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"
