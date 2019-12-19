if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%F{red}%? ↵%f)"

PROMPT='%F{$NCOLOR}%n%f@%F{cyan}%m\
%f:%F{magenta}%~\
$(git_prompt_info) \
%F{red}%(!.#.»)%f '
PROMPT2='%F{red}\ %f'
RPS1='${return_code}'

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}("
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}○%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}⚡%f"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{yellow})%f"
