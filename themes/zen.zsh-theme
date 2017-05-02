# zen.zsh-theme
#
# Author: Wojciech Matyskiewicz
# URL: http://www.matyskiewicz.com/
# Direct Link: https://github.com/wmatyskiewicz/oh-my-zsh/tree/master/themes/zen.zsh-theme
#
# Last modified on:  Apr 26, 2013


ZSH_THEME_GIT_PROMPT_PREFIX="$FG[245][git: %{$reset_color%}$FG[032]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[245]]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[214]*%{$reset_color%}"

PROMPT="$FG[032][%*] %n@%m %~ %{$reset_color%}
$FG[214] %(!.#.»)%{$reset_color%} "

RPROMPT="$(git_prompt_info)"
