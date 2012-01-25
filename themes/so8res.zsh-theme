function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '»' && return
    hg root >/dev/null 2>/dev/null && echo '⇒' && return
    echo '→'
}
function battery_charging {
    if [[ $(acpi -b) == *Discharging* ]] ; then echo 0; else echo 1; fi
}
function battery_charge {
    echo $(acpi -b | sed 's/.*, \([0-9]\+\).*/\1/')
}
function battery_mode {
    if [[ $(battery_charging) -eq 1 ]] ; then
        echo "%{$fg[blue]%}"
    elif [[ $(battery_charge) -ge 70 ]] ; then
        echo "%{$fg[green]%}"
    elif [[ $(battery_charge) -ge 30 ]] ; then
        echo "%{$fg[yellow]%}"
    elif [[ $(battery_charge) -ge 12 ]] ; then
        echo "%{$fg[red]%}%B"
    else
        echo "%{$fg[red]%}%S%B"
    fi
}
function battery_info {
    if [[ $(battery_charging) -eq 1 ]] ; then
        if [[ $(battery_charge) -lt 98 ]] ; then
            echo "["$(battery_charge)"%%]"
        fi
    else
        echo "["$(battery_charge)"%%]"
    fi
}

COLOR_NAME='%{$fg[magenta]%}'
COLOR_HOST='%{$fg[yellow]%}'
COLOR_DIR='%{$fg[green]%}'
COLOR_ARROW='%{$fg[cyan]%}'

COLOR_DAYNAME='%{$fg[magenta]%}'
COLOR_DAYNUM='%{$fg[magenta]%}%B'
COLOR_MONTH='%{$fg[yellow]%}%b'
COLOR_TIME='%{$fg[green]%}'

COLOR_RESET='%{$reset_color%}%s%u%b'
COLOR_SPACE='%{$fg[white]%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"'!'
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[magenta]%}"'*'
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"' ✔'

RPROMPT=$COLOR_DAYNAME\$(date +"%a")' '$COLOR_DAYNUM\$(date +"%d")' '$COLOR_MONTH\$(date +"%b")' '$COLOR_TIME\$(date +"%H:%M")' '\$(battery_mode)\$(battery_info)$COLOR_RESET

PROMPT=$COLOR_NAME'%n'$COLOR_SPACE'@'$COLOR_HOST'%m'$COLOR_SPACE':'$COLOR_DIR\$(collapse_pwd)\$(git_prompt_info)$COLOR_ARROW'
'\$(prompt_char)' '$COLOR_RESET
