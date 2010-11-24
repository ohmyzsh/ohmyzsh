# the idea of this theme is to contain a lot of info in a small string, by compressing some parts,
# and colorcoding, which bring useful visual cues.  While limiting the amount of colors and such to keep
# it easy on the eyes
# exact return code (when >0) is on the right, so it stays out of the way

# TODO: reset exit code visual cues (not exit code itself) after showing once
# TODO: compress hostname in window title

typeset -A host_repr
host_repr=('dieter-ws-a7n8x-arch' "%{$fg_bold[green]%}ws" 'dieter-p4sci-arch' "%{$fg_bold[blue]%}p4")


# local time, color coded after last return code
local time="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"
# user part, color coded after privileges
local user="%(!.%{$fg[blue]%}.%{$fg[blue]%})%n%{$reset_color%}"
# Hostname part.  compressed and colorcoded per host_repr array
# if not found, regular hostname in default color
local host="@${host_repr[$(hostname)]:-$(hostname)}%{$reset_color%}"
# Compacted $PWD
local pwd="%{$fg[blue]%}%c%{$reset_color%}"

PROMPT='${time} ${user}${host} ${pwd} $(git_prompt_info)'

# i would prefer 1 icon that shows the "most drastic" deviation from head, but lets see how this works out
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%} %{$fg[yellow]%}?%{$fg[green]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

# elaborate exitcode on the right when >0
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
RPS1="${return_code}"
