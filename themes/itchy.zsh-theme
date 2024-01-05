local smiley="%(?,%F{green}☺%f,%F{red}☹%f)"

local user="%F{cyan}%n%f"
local host="%F{cyan}@%m%f"
local pwd="%F{yellow}%~%f"

PROMPT='${user}${host} ${pwd}
${smiley}  '

RPROMPT='$(ruby_prompt_info) %F{white}$(git_prompt_info)%f'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red} ✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green} ✔%f"

ZSH_THEME_RUBY_PROMPT_PREFIX=""
ZSH_THEME_RUBY_PROMPT_SUFFIX=""
