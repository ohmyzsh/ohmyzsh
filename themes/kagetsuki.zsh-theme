# Kagetsuki ZSH theme
# by Rei Kagetsuki
#
#
# used the following to get color codes
# for code in {000..255}; do print -nP -- "%F{$code}$code %f"; [ $((${code} % 16)) -eq 15 ] && echo; done

# most terminals support 256 color... but don't enable it!?
export TERM="xterm-256color"

# The prompt
function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo "$"; fi
}
PROMPT='[%F{197}%n%F{236}@%F{037}%m%F{159}:%F{031}%~%{$fg[white]%}]%_$(prompt_char) %{$reset_color%}' #'%{$fg[magenta]%}[%c] %{$reset_color%}'

# The right-hand prompt
RPROMPT='%{$fg[magenta]%}$(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%}${time}'

# local time, color coded by last return code
time_enabled="%(?.%{$fg[white]%}.%{$fg[red]%})%*%{$reset_color%}"
time_disabled="%{$fg[green]%}%*%{$reset_color%}"
time=$time_enabled

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}G["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[white]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{208}汚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{045}跡"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{118}清"

ZSH_THEME_GIT_PROMPT_MODIFIED="%F{197}改"
ZSH_THEME_GIT_PROMPT_ADDED="%F{087}加"
ZSH_THEME_GIT_PROMPT_DELETED="%F{087}削"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{087}変"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{129}合"
