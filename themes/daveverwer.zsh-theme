# Copied and modified from the oh-my-zsh theme from geoffgarside
# Red server name, green cwd, blue git status

PROMPT='%F{red}%m%f:%F{green}%c%f$(git_prompt_info) %(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{blue}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"
