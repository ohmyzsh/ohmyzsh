CIACHO_VERSION="0.1d"
function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function ssh_connection() {
	if [[ -n $SSH_CONNECTION ]]; then
		echo "%{$fg_bold[green]%}(ssh)%{$reset_color%} "
	elif [[ -n $SUDO_USER ]]; then
		echo "%{$fg_bold[red]%}(sudo)%{$reset_color%} "
	 fi
}

function vps_check() {
  if [[ -f /etc/vps ]]; then
    echo "%{$fg_bold[red]%}(VPS)%{$reset_color%} "
  fi
}

function ciacho_version() {
  if [[ -n $CIACHO_VERSION ]]; then
    echo " %{$fg_bold[blue]%}($CIACHO_VERSION)%{$reset_color%} "
  fi
}

function locale_check() {
        if [[ $LANG == "pl_PL.UTF-8" ]]; then
                L_CODETITLE="%{$fg_bold[green]%}(UTF)%{$reset_color%} "
	elif [[ $LANG == "pl_PL" ]]; then
                L_CODETITLE="%{$fg_bold[white]%}(ISO)%{$reset_color%} "
#        else
#               L_CODETITLE="%{$fg_bold[green]%}(ISO)%{$reset_color%} "
        fi
    echo $L_CODETITLE
}

        if [[ $( whoami ) == root && -f /etc/vps ]]; then
		## czerwony @ bialy
                l_user="%{$fg_bold[red]%}%n%{$reset_color%}"
		l_host="%{$fg_bold[white]%}%m%{$reset_color%}"
                l_pwd="%{$fg_bold[red]%}%#%{$reset_color%}"
        elif [[ $( whoami ) == root ]]; then
		## czerwony @ cyan
                l_user="%{$fg_bold[red]%}%n%{$reset_color%}"
		l_host="%{$fg_bold[cyan]%}%m%{$reset_color%}"
                l_pwd="%{$fg_bold[red]%}%#%{$reset_color%}"
        elif [[ $( hostname ) == jail || -f /etc/vps ]]; then
		## bialy @ czerwony
                l_user="%{$fg_bold[white]%}%n%{$reset_color%}"
		l_host="%{$fg_bold[red]%}%m%{$reset_color%}"
                l_pwd="%{$fg_bold[white]%}%#%{$reset_color%}"
        elif [[ $( hostname ) == "Varacolaci.local" ]]; then
		## bialy @ czerwony
                l_user="%{$fg_bold[blue]%}%n%{$reset_color%}"
		l_host="%{$fg_bold[red]%}%m%{$reset_color%}"
                l_pwd="%{$fg_bold[white]%}%#%{$reset_color%}"
#        elif [[ $( hostname ) == "Varacolaci.local" ]]; then
#                l_user=$PR_BLUE"%n"$PR_RESET" "$PR_BOLD_RED"%m"$PR_RESET
#        elif [[ $( uname ) == Darwin ]]; then
#                l_user=$PR_BLUE"%n"$PR_RESET" "$PR_BLUE"%m"$PR_RESET
        else
                l_user="%{$fg_bold[green]%}%n%{$reset_color%}"
		l_host="%{$fg_bold[green]%}%m%{$reset_color%}"
                l_pwd="%{$fg_bold[green]%}%#%{$reset_color%}"
        fi
function user_check() {
		echo "$l_user@$l_host"
}


function ciacho_battery() {
	if [[ $(uname) == "Darwin" ]] ; then
		if [[ $(ioreg -rc AppleSmartBattery | grep -c '^.*"ExternalConnected"\ =\ No') -eq 1 ]] ; then
			b=$(battery_pct)
			if [ $b -gt 50 ] ; then
				color='green'
			elif [ $b -gt 20 ] ; then
				color='yellow'
			else
				color='red'
			fi
			echo "%{$fg[$color]%}[$(battery_pct_remaining)%%]%{$reset_color%} :"
		else
			echo "%{$fg[yellow]%}[∞]%{$reset_color%} :"
		fi

	fi
}

#PROMPT=$'\n$(ssh_connection)$(vps_check)$(locale_check)$(user_check)%{$reset_color%}$(ciacho_version)$(my_git_prompt) : %~\n%# '
PROMPT=$'\n$(ssh_connection)$(vps_check)$(locale_check)$(user_check)%{$reset_color%}$(ciacho_version)$(my_git_prompt) : $(ciacho_battery) %~\n$l_pwd '

ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" $fg[white]‹ %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" $fg_bold[white]›%{$reset_color%}"

