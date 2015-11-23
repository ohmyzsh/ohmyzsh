# Theme with full path names and hostname
# Handy if you work on different servers all the time;


## Git plugin 
function my_git_prompt_info {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	GIT_STATUS=$(git_prompt_status)
	[[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%%"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_RENAMED="~"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_UNMERGED="?"

# My prompt with colors
local ESSEMBEH_PROMPT_EXTRA=""
local ESSEMBEH_PROMPT_HOST_COLOR="green"
test -r /etc/debian_chroot && ESSEMBEH_PROMPT_EXTRA="%{$fg[yellow]%}[chroot:$(cat /etc/debian_chroot)]%{$reset_color%} "
test -r /.dockerenv        && ESSEMBEH_PROMPT_EXTRA="%{$fg[yellow]%}[docker]%{$reset_color%} "
test -n "$SSH_CONNECTION"  && ESSEMBEH_PROMPT_EXTRA="%{$fg[yellow]%}[$(echo $SSH_CONNECTION | awk '{print $1}')]%{$reset_color%} "
test -n "$SSH_CONNECTION"  && ESSEMBEH_PROMPT_HOST_COLOR="red"
test    "$UID" = "0"       && ESSEMBEH_PROMPT_HOST_COLOR="magenta"
local ESSEMBEH_PROMPT_HOST="%{$fg[$ESSEMBEH_PROMPT_HOST_COLOR]%}%n@%M%{$reset_color%}"
local ESSEMBEH_PROMPT_PWD="%{%B$fg[yellow]%}%~%{$reset_color%b%}"

PROMPT='${ESSEMBEH_PROMPT_EXTRA}${ESSEMBEH_PROMPT_HOST}:${ESSEMBEH_PROMPT_PWD} $(my_git_prompt_info)%(!.#.$) '
RPS1="%(?..%{$fg[red]%}%?%{$reset_color%})"

