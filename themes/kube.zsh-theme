# kube.zsh-theme

COLOR_WHITE="%{$fg[white]%}"
COLOR_YELLOW="%{$fg[yellow]%}"
COLOR_CYAN="%{$fg[cyan]%}"
COLOR_BLUE="%{$fg[blue]%}"
COLOR_MAGENTA="%{$fg[magenta]%}"
COLOR_GREEN="%{$fg[green]%}"
COLOR_RED="%{$fg[red]%}"

ZSH_THEME_GIT_PROMPT_PREFIX="$COLOR_WHITE:$COLOR_BLUE"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN=" $COLOR_GREEN✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" $COLOR_RED✗"

TIME="$COLOR_WHITE"["$COLOR_YELLOW%T$COLOR_WHITE"]"%{$reset_color%}"
KUBE="$COLOR_WHITE"["$COLOR_MAGENTA$(kubectl config current-context)$COLOR_WHITE"]
DIR="$COLOR_CYAN%~\$(git_prompt_info) "
PROMPT="$COLOR_WHITE➭ "

PROMPT="$TIME$KUBE$DIR$PROMPT%{$reset_color%}"