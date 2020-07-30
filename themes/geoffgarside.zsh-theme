# PROMPT="[%*] %n:%c $(git_prompt_info)%(!.#.$) "
PROMPT='[%*] %F{cyan}%n%f:%F{green}%c%f$(git_prompt_info) %(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{yellow}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"
