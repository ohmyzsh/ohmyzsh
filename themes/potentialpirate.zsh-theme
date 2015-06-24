# Copied and modified from the oh-my-zsh theme from geoffgarside
# Red server name, green cwd, blue git status

PROMPT='%{$FG[225]%}%m%{$reset_color%}:%{$FG[226]%}%c%{$reset_color%}$(git_prompt_info) %(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[168]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
