autoload -U promptinit
promptinit
autoload -U colors; colors

case $USER in
    'root')
    export PS1="$PS1_NAME$PS1_TIME$PS1_PATH[0;31m# "
    local user_prompt="%B$fg[red]%b%% "
    ;;

    *)
    local user_prompt="%B$fg[magenta]%b%% "
    ;;
esac

local HOST_STRING="$fg[green]`hostname`"
local blue_ob="%{%B$fg[blue]%}[%{$reset_color%}%b"
local blue_cb="%{%B$fg[blue]%}]%{$reset_color%}%b"
local blue_op="%{%B$fg[blue]%}(%{$reset_color%}%b"
local blue_cp="%{%B$fg[blue]%})%{$reset_color%}%b"
local path_p="${blue_ob}$fg[red]%~${blue_cb}"
local user_host="${blue_ob}${HOST_STRING}$fg[magenta]@$fg[green]%m${blue_cb}"
local ret_status="${blue_ob}$fg[yellow]ret:%?${blue_cb}"
local hist_no="${blue_ob}$fg[yellow]hist:%h${blue_cb}"
local panic="${blue_ob}%(?,%{$fg[green]%}%BDON'T PANIC%b%{$reset_color%},%{$fg[red]%}>> PANIC <<%{$reset_color%})${blue_cb}"
local smiley="%(?,%{$fg[green]%}:%)%{$reset_color%},%{$fg[red]%}:(%{$reset_color%})"


function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo "${fg[red]}git ∓∓∓${reset_color}" && return
    # hg root >/dev/null 2>/dev/null && echo "${fg[red]}hg ☿${reset_color}" && return
    # svn info >/dev/null 2>/dev/null && echo "${fg[red]}svn s${reset_color}" && return
    echo "${fg[blue]}○${reset_color}"
}

function battery_charge {
    [[ ! ($1 == "arrows" || $1 == "steps") ]] && print "usage $0 arrows|steps [opt: CurrentCapacity]" && exit
    [[ -e /usr/bin/pmset ]] || return

    s=`pmset -g ps`
    # "Currently drawing from 'AC Power'"
    # "-InternalBattery-0   54%; charging; 0:51 remaining"

    [[ -z $s ]] && return
    [[ -z $1 && -z $2 ]] && return
    [[ $1 == 'arrows' ]] && base=10
    [[ $1 == 'steps' ]] && base=8

    [[ ! -z $2 ]] && cur=$2

    percent=`pmset -g batt | awk '/-InternalBattery-0/ {print $2}'`
    percent=${percent%%%*}

    fuel=$(( $percent / $base ))
    # fuel=`echo "scale=1; $percent/$base" | bc -q`

    # color=""
    # if [[ $fuel -ge 9 ]]; then
    # 	#full
    # 	color="$terminfo[bold]$fg[green]"
    # elif [[ $fuel -ge 8 ]]; then
    # 	#good
    # 	color="$fg[green]"
    # elif [[ $fuel -ge 5 ]]; then
    # 	#ok
    # 	color="$fg[orange]"
    # elif [[ $fuel -ge 3 ]]; then
    # 	#low
    # 	color="$terminfo[bold]$fg[yellow]"
    # elif [[ $fuel -ge 1 ]]; then
    # 	#bad
    # 	color="$fg[red]"
    # fi

    if [[ $1 == arrows ]]; then
    	full='▶'
    	part='▷'
    	display=""
    	for (( i = 1; i <= $fuel; i++ )); do
    		display=$display$full
    	done
    	for (( i = $fuel; i < 10; i++ )); do
    		display=$display$part
    	done
    fi

    if [[ $1 == steps ]]; then
    	level="▁▂▃▄▅▆▇▉"
    	for (( i = 1; i <= $fuel; i++ )); do
    		display=$display$level[$i]
    	done
    	for (( i = $fuel; i < 8; i++ )); do
    		display=" "$display
    	done
    fi

    print "${display}"
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo "${blue_op}$fg[magenta]"`basename $VIRTUAL_ENV`"$fg[reset]${blue_cp}─"
}

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function hg_prompt_info() {
    hg prompt --angle-brackets "\
< on %{$fg[magenta]%}<branch>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}


function parse_git_dirty2() {
  gitstat=$(git status -u 2>/dev/null | grep '\(# Untracked\|# Changes\|# Changed but not updated:\)'&)
  if [[ $(echo ${gitstat} | grep -c "^# Changes to be committed:$") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
      fi
  if [[ $(echo ${gitstat} | grep -c "^\(# Untracked files:\|# Changed but not updated:\)$") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi
  if [[ $(echo ${gitstat} | grep -v '^$' | wc -l | tr -d ' ') == 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# get the name of the branch we are on
function git_prompt_info2() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  branch=${ref#refs/heads/}
  sha=$(git rev-parse --short ${branch})
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${branch}%{$fg[green]%}@%{$fg[magenta]%}${sha}$ZSH_THEME_GIT_PROMPT_SUFFIX$(parse_git_dirty2)"
}

PROMPT='╭─$(virtualenv_info)$(prompt_char)$(git_prompt_info2)─${user_host}─${path_p}─${panic}-${ret_status}─${hist_no}
╰─${blue_ob}${smiley}${blue_cb}${user_color}─> ⚡ '
PROMPT2='${blue_ob}$_${blue_cb}> '

# righthand side

RPROMPT='$(battery_charge arrows)'

