# see http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html for color codes
PROMPT_PREFIX="$(xterm_color 243 '%n')$(xterm_color 240 '@')$(xterm_color 238 '%m')"

PROMPT='$PROMPT_PREFIX $(xterm_color 76 "${PWD/#$HOME/~}") $SCM_PROMPT_INFO 
$(scm_prompt_char)> '

RPROMPT='$RPROMPT_SUFFIX'

ZSH_THEME_GIT_PROMPT_PREFIX="on $(xterm_color_open 220)"
ZSH_THEME_GIT_PROMPT_SUFFIX="$(xterm_color_reset)"
ZSH_THEME_GIT_PROMPT_DIRTY=" $(xterm_color 196 '(!)')"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" $(xterm_color 33 '(+)')"
ZSH_THEME_GIT_PROMPT_CLEAN=""
