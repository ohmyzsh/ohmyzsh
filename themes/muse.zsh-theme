PROMPT="${FG[117]}%~%{$reset_color%}\$(git_prompt_info)\$(virtualenv_prompt_info)${FG[133]}\$(git_prompt_status) ${FG[077]}ᐅ%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[012]}("
ZSH_THEME_GIT_PROMPT_SUFFIX="${FG[012]})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" ${FG[133]}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" ${FG[118]}✔"

ZSH_THEME_GIT_PROMPT_ADDED="${FG[082]}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="${FG[166]}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="${FG[160]}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="${FG[220]}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="${FG[082]}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${FG[190]}✭%{$reset_color%}"

ZSH_THEME_VIRTUALENV_PREFIX=" ["
ZSH_THEME_VIRTUALENV_SUFFIX="]"
