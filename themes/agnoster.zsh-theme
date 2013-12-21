# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''
SEG_2=''
ip=`curl -s icanhazip.com`
# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$reset_color%}%{$fg[black]%}%{$bg`echo '\033[104;32m'`%}$SEGMENT_SEPARATOR%{$bg%F{$CURRENT_BG}%}%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
	prompt_segment black default "%{$fg[red]%}%(!.%{%F{yellow}%}.)%n%{$fg[white]%}@%{$fg[blue]%}`scutil --get ComputerName`%{$reset_color%}%{$fg[black]%}%{`echo '\033[42m'`%}$SEGMENT_SEPARATOR$ip"
  fi
}
#   prompt_segment black default "%{$fg[red]%}%(!.%{%F{yellow}%}.)%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}%{$fg[black]%}`echo '\033[106m'`$SEGMENT_SEPARATOR$ip%{$reset_color%}%"

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:git:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats '%u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//± }${vcs_info_msg_0_}"
  fi
}

prompt_hg() {
	local rev status
	if $(hg id >/dev/null 2>&1); then
		if $(hg prompt >/dev/null 2>&1); then
			if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
				# if files are not added
				prompt_segment red white
				st='±'
			elif [[ -n $(hg prompt "{status|modified}") ]]; then
				# if any modification
				prompt_segment yellow black
				st='±'
			else
				# if working copy is clean
				prompt_segment green black
			fi
			echo -n $(hg prompt "☿ {rev}@{branch}") $st
		else
			st=""
			rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
			branch=$(hg id -b 2>/dev/null)
			if `hg st | grep -Eq "^\?"`; then
				prompt_segment red black
				st='±'
			elif `hg st | grep -Eq "^(M|A)"`; then
				prompt_segment yellow black
				st='±'
			else
				prompt_segment green black
			fi
			echo -n " $rev@$branch" $st
		fi
	fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue white "%{`echo '\033[44;32m'`%} %~ "
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -z $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_git
  prompt_hg
  prompt_end
}


typeset -Ag FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

# Show all 256 colors with color number
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "zz $code: %F{$code}zzz"
  done
}


function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '%(!.!.➜)'
}
 
 
function parse_hg_dirty {
  if [[ -n $(hg status -mard . 2> /dev/null) ]]; then
    echo "$ZSH_THEME_HG_PROMPT_DIRTY"
  fi
}
 
function get_RAM {
  top -l1 | grep "PhysMem"| awk '{print (int($6)/1024)}'
}
 
 
function get_load() {
  uptime | awk '{print $11}' | tr ',' ' '
}
 
function battery_charge {
    echo `~/.oh-my-zsh/custom/battery.py` 2>/dev/null
}

#case '~/*' in '~/' ) echo "yes";;
#  * ) echo "no";;
#esac

function user_folder_check {
string='/Users/rever';
path=`pwd`;
if [[ $path == *$string* ]]
then
  echo "Local";
else
  echo "External";
fi
}
RPROMPT='%{$fg_bold[white]%}$(user_folder_check) %{$fg_bold[green]%}%t%{$reset_color%} $(battery_charge)'

PROMPT='%{%f%b%k%}$(build_prompt)  '
