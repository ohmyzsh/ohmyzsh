#Some cool additions to the awesome pygmalion theme
#Milind Shakya

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_SVN_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%} "

ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%} ✘ %{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN=" "

setprompt(){
if which acpi &> /dev/null; then
        local BATTSTATE="$(acpi -b)"
        local BATTPRCNT="$(echo ${BATTSTATE[(w)4]}|sed -r 's/(^[0-9]+).*/\1/')"
        local BATTSTATUS="$(echo ${BATTSTATE[(w)3]})"
        if [[ "${BATTSTATUS}" = "Discharging," ]]; then
            if [[ -z "${BATTPRCNT}" ]]; then
                PR_BATTERY=""
            elif [[ "${BATTPRCNT}" -lt 15 ]]; then
                PR_BATTERY="${fg[red]%}|${fg[red]} batt:${BATTPRCNT}%%"
            elif [[ "${BATTPRCNT}" -lt 60 ]]; then
                PR_BATTERY="${fg[red]%}|${fg[yellow]} batt:${BATTPRCNT}%%"
            elif [[ "${BATTPRCNT}" -lt 100 ]]; then
                PR_BATTERY="${fg[red]%}|${fg[green]} batt:${BATTPRCNT}%%"
            else
                PR_BATTERY=""

            fi
        else
            PR_BATTERY=""
        fi
    fi

PROMPT='$fg[magenta]%}%n%{$reset_color%}%{$fg[cyan]%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}%{$fg[red]%}:%{$reset_color%}%{$fg[cyan]%}%0~%{$reset_color%}${PR_BATTERY%}%{$reset_color%}%{$fg[red]%}|%{$reset_color%}$(git_prompt_info)$(svn_prompt_info)%{$reset_color%}%{$fg[cyan]%}⇒%{$reset_color%} '
}

 precmd() { PS1= setprompt }

 setprompt

