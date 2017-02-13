# Fork and mash of many other prompts.
#
# Has user, host, full path, and time/date along with vcs info.
# on two lines for easier visual grepping
# entry in a nice long thread on the Arch Linux forums:
#   http://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
#
# If you do not wish to have vcs info redefine function rkj_vcs_info to be empty.

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}✈"

rkj_hg_prompt_info() {
  hg root > /dev/null 2>&1 || return
  echo -n "hg:($( hg id --tags )%{$reset_color%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

rkj_git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo -n "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$( git_prompt_status )%{$reset_color%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

rkj_vcs_info() {
  rkj_git_prompt_info
  rkj_hg_prompt_info
}

# random prompt sign
signs=(@ ☢ ☸ ☹ ☺ ☻ ☼ ☀ ☄ ☠ ☣ ☯ ♈ ♻ ♼ ♽ ⚙)
rkj_prompt() {
  echo $signs[$[${RANDOM} % ${#signs}]]
}

rkj_retcode() {
  return $?
}

type rkj_debug >/dev/null || rkj_debug() { }

short_fortune() {
  rkj_debug fortune start
  local prompt_variable_part=$'%n%m%~%D{"$PROMPT_DATE_FORMAT"}'
  if hash fortune 2>/dev/null; then
    local left=$(( $COLUMNS - ${#${(%)prompt_variable_part}} - 15))
    rkj_debug Left $left, $COLUMNS available
    [[ $left -gt 30 ]] && fortune -s -n $left | tr -s "\n\t " "   "
  else
    echo "no fortunes for you"
  fi
  rkj_debug fortune finished
}
PROMPT_DATE_FORMAT=$'%Y-%m-%d %I:%M:%S'
LINE1=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;30m%}@%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"${PROMPT_DATE_FORMAT}"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%}'
PROMPT=$'$LINE1 $(short_fortune)
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}%?$(rkj_retcode)%{\e[0;34m%}%B] $(rkj_vcs_info)$(rkj_prompt)%{\e[0m%}%b '
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '

