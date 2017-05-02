# This theme is based on mortalscumbag.
# It was a bit updated to look better with solarized dark theme.
# Made by Alex Lourie <djay.il@gmail.com>, @alourie on Twitter
# Feel free to change it or ask me to do that for you.


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

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(project_name)$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh) "
  fi
}

function get_project_top_level {
    while [ `pwd` != '/' ]; do
        if [ -e .git ]; then
            basename `pwd`
            return
        else
            cd ..
        fi
    done
}

function project_name() {
   b=$(parse_git_branch_and_add_brackets)
   if [[ $b == "" ]]; then
    echo ""
   else
    echo " $PROJECT_NAME_COLOR$(get_project_top_level)$reset_color:$PROMPT_BRANCH_COLOR"
   fi
}

function parse_git_branch_and_add_brackets {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# COLOR DEFINITIONS, taking from terminal colors
SLR_RED=%{$fg[red]%}
SLR_BLUE=%{$fg[blue]%}
SLR_GREEN=%{$fg[green]%}
SLR_WHITE=%{$fg[white]%}
SLR_YELLOW=%{$fg[yellow]%}
SLR_CYAN=%{$fg[cyan]%}
SLR_MAGENTA=%{$fg[magenta]%}
SLR_ORANGE=%{$fg_bold[red]%}
SLR_SIMPLE=%{$fg_bold[blue]%}
SLR_BOLDWHITE=%{$fg_bold[white]%}
SLR_DARKSEA=%{$fg_bold[green]%}
SLR_LIGHTSEA=%{$fg_bold[yellow]%}
SLR_VIOLET=%{$fg_bold[magenta]%}

# PROMPT PARTS COLORS
HOST_COLOR=$SLR_LIGHTSEA
PROJECT_NAME_COLOR=$SLR_BLUE
PROMPT_BRANCH_COLOR=$SLR_GREEN

local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})%?%{$reset_color%}"
PROMPT=$'\n$(ssh_connection)$HOST_COLOR%n@%m%{$reset_color%}$(my_git_prompt) : %~\n[${ret_status}] %# '

ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" $fg[white]["
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" $fg_bold[white]]%{$reset_color%}"
