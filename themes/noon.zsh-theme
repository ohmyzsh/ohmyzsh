# "noon" by Noon Silk.
#
# This theme is essentially "dieter", with a bit of stuff removed (git related
# prompt stuff). I also added the time into the prompt, and the date on the 
# right prompt. The comments below are his.
#
# --

# the idea of this theme is to contain a lot of info in a small string, by
# compressing some parts and colorcoding, which bring useful visual cues,
# while limiting the amount of colors and such to keep it easy on the eyes.
# When a command exited >0, the timestamp will be in red and the exit code
# will be on the right edge.
# The exit code visual cues will only display once.
# (i.e. they will be reset, even if you hit enter a few times on empty command prompts)

# local time, color coded by last return code
time_enabled="%(?.%{$fg[magenta]%}.%{$fg[red]%})%D{%I:%M %p}%{$reset_color%}"
time_disabled="%{$fg[magenta]%}%D{%I:%M %p}%{$reset_color%}"
time=$time_enabled

# user part, color coded by privileges
local user="%(!.%{$fg[white]%}.%{$fg[white]%})%n@%{$reset_color%}"

# Compacted $PWD
local pwd="%{$fg[yellow]%}%c>%{$reset_color%}"

PROMPT='${time} ${user}${pwd}'

# elaborate exitcode on the right when >0
return_code_enabled="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
return_code_disabled="%{$fg[magenta]%}%D{%a %b %d}%{$reset_color%}"
return_code=$return_code_disabled

RPROMPT='${return_code}'

function accept-line-or-clear-warning () {
	if [[ -z $BUFFER ]]; then
		time=$time_disabled
		return_code=$return_code_disabled
	else
		time=$time_enabled
		return_code=$return_code_enabled
	fi
	zle accept-line
}
zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
