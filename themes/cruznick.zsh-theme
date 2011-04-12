
prompt_char() {
    if [[ -d .git ]]; then
	echo "%F{cyan}±%f" || return
    elif [[ -d .hg ]]; then
	echo "%F{cyan}☿%f" || return
    elif [[ -d .svn ]]; then
	"%F{cyan}☿%f"
    fi

}
custom_prompt_info() {
    if [[ -d .git ]]; then
	echo  "$(git_prompt_info)%F{green}<->%f[$(git_prompt_status)]" || return
    elif [[ -d .hg ]]; then
	echo "$(hg_prompt_info)"
    fi
   
}
command_succes() {
if [ $? = 0 ]
then 
	echo "%F{yellow}^_^%f"
else 
	echo "%F{red}O_O%f"
fi
}

PROMPT='┌[%F{green}%3c%f] $(custom_prompt_info) 
└[%F{green}%#%f]>> '
RPROMPT='$(command_succes) $(batt_prompt_perc)$(bat_prompt_acstt) $(prompt_char)'


ZSH_THEME_GIT_PROMPT_PREFIX="[%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}°%f"

ZSH_THEME_GIT_PROMPT_ADDED="%F{green}+%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{blue}*%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{red}x%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{magenta}->%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{yellow}═%f"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{cyan}?%f"

ZSH_THEME_ACBAT_PROMPT_CHARGED="%F{green}°%"
ZSH_THEME_ACBAT_PROMPT_CHARGING="%F{cyan}+%"
ZSH_THEME_ACBAT_PROMPT_DISCHARGING="%F{yellow}-%"

ZSH_THEME_BATPERC_PROMPT_PREFIX="%F{yellow}⚡% :"
#ZSH_THEME_BATPERC_PROMPT_SUFFIX=""
ZSH_THEME_BATPERC_PROMPT_CLRLESS25PRC="red"
ZSH_THEME_BATPERC_PROMPT_CLRMORE80PRC="cyan"
ZSH_THEME_BATPERC_PROMPT_CLR40TO80PRC="green"
ZSH_THEME_BATPERC_PROMPT_CLR25TO40PRC="yellow"

ZSH_THEME_HG_PROMPT_PREFIX="[%F{yellow}"
ZSH_THEME_HG_PROMPT_SUFFIX="%f]"

