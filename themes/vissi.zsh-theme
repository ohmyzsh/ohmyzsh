function battery_charge {
  # Battery 0: Discharging, 94%, 03:46:34 remaining
  bat_percent=`acpi | awk -F ':' {'print $2;'} | awk -F ',' {'print $2;'} | sed -e "s/\s//" -e "s/%.*//"`

  if [ $bat_percent -lt 20 ]; then cl='%F{red}'
  elif [ $bat_percent -lt 50 ]; then cl='%F{yellow}'
  else cl='%F{green}'
  fi

  filled=${(l:`expr $bat_percent / 10`::▸:)}
  empty=${(l:`expr 10 - $bat_percent / 10`::▹:)}
  echo $cl$filled$empty'%F{default}'
}

PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
if [ -x /usr/bin/acpi ]; then
	RPROMPT="%T %D $(battery_charge)"
else
	RPROMPT="%T %D"
fi

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
