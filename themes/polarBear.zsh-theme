# PolarBear
# By Travis Crist
# Based on the Deiter Theme from: 
# https://github.com/sjl/oh-my-zsh/blob/master/themes/dieter.zsh-theme
# For best results use with Solarized Dark: http://ethanschoonover.com/solarized

# The idea of this theme is to take the deiter theme and simplify it. Many 
# of us do not need the username or hostname on our cmd line but would like to know which directory
# we are in and have a fun prompt. This theme shows your current directory and allows
# you to add a custom prompt of your choosing. I chose a Polar Bear which is why I have
# Nicknamed this theme that. 

# When a command exited >0, the timestamp will be in red and the exit code
# will be on the right edge.
# The exit code visual cues will only display once.
# (i.e. they will be reset, even if you hit enter a few times on empty command prompts)

# local time, color coded by last return code
#original
#time_enabled="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"
time_enabled="%(?.%{$fg[green]%}.%{$fg[red]%})%D{%I:%M:%S}%{$reset_color%}"
time_disabled="%{$fg[green]%}%*%{$reset_color%}"
time=$time_enabled

# Local Directory
local directory="%{$reset_color%}%{$fg[cyan]%}[%~]%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%} %{$fg[yellow]%}?%{$fg[green]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
ZSH_THEME_SVN_PROMPT_PREFIX=$ZSH_THEME_GIT_PROMPT_PREFIX
ZSH_THEME_SVN_PROMPT_SUFFIX=$ZSH_THEME_GIT_PROMPT_SUFFIX
ZSH_THEME_SVN_PROMPT_DIRTY=$ZSH_THEME_GIT_PROMPT_DIRTY
ZSH_THEME_SVN_PROMPT_CLEAN=$ZSH_THEME_GIT_PROMPT_CLEAN

vcs_status() {
    if [[ ( $(whence in_svn) != "" ) && ( $(in_svn) == 1 ) ]]; then
        svn_prompt_info
    else
        git_prompt_info
    fi
}


# Create the prompt clean and basic, just the info you need
PROMPT='${time} ${directory}$(vcs_status) $(prompt_char) '


# elaborate exitcode on the right when >0
return_code_enabled="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
return_code_disabled=
return_code=$return_code_enabled

RPS1='${return_code}'

function prompt_char() {
  # echo "%{$fg[yellow]%}◯%{$reset_color%}"
  echo "%{$fg[white]%}óÔÔò ʕ·͡ᴥ·ʔ óÔÔò%{$reset_color%}"
}

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
