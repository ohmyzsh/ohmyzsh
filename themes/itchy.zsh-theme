<<<<<<< HEAD
# Inspired by http://peepcode.com/blog/2012/my-command-line-prompt

=======
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
local smiley="%(?,%{$fg[green]%}☺%{$reset_color%},%{$fg[red]%}☹%{$reset_color%})"

local user="%{$fg[cyan]%}%n%{$reset_color%}"
local host="%{$fg[cyan]%}@%m%{$reset_color%}"
local pwd="%{$fg[yellow]%}%~%{$reset_color%}"

PROMPT='${user}${host} ${pwd}
${smiley}  '

<<<<<<< HEAD
RPROMPT='$(rvm-prompt || rbenv version) %{$fg[white]%}$(git_prompt_info)%{$reset_color%}'
=======
RPROMPT='$(ruby_prompt_info) %{$fg[white]%}$(git_prompt_info)%{$reset_color%}'
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔%{$reset_color%}"

<<<<<<< HEAD
=======
ZSH_THEME_RUBY_PROMPT_PREFIX=""
ZSH_THEME_RUBY_PROMPT_SUFFIX=""
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
