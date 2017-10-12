# ys-pep Theme, based on ys Theme by Yad Smood
#
# ----- BEGIN Original Description -----
#
# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood
#
# ----- END Original Description -----
#
# Changes to ys theme:
#   * Move timestamp to the front and make it darker
#   * List current IP addresses
#   * GCE hook (for controlling Google Cloud)
#   * Virtualenv hook
#   * Fix Mercurial detection
#
# Sep-Oct 2017 Pandu POLUAN <pepoluan@gmail.com>

# VCS
YS_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
	# make sure this is a Mercurial project
	if [ -d '.hg' ] || $(hg summary > /dev/null 2>&1) ; then
		echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$YS_VCS_PROMPT_DIRTY"
		else
			echo -n "$YS_VCS_PROMPT_CLEAN"
		fi
		echo -n "$YS_VCS_PROMPT_SUFFIX"
	fi
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%} )"

### BEGIN: pepoluan changes ###
local dgrey="$terminfo[bold]$fg[black]"

# Show my IP Address
ZSH_THEME_SHOW_IP=1
yspep_my_ip() {
  [[ $ZSH_THEME_SHOW_IP != 1 ]] && return
  echo -n "%{$dgrey%}[%{$fg[green]%}"
  local i
  if [[ ${(L)_system_name} == cygwin ]]; then
    echo -n $(ipconfig | awk '$1 ~ /IP/ && $2 ~ /[Aa]ddress/ {sub(/.*:/, "", $0); gsub(/[ \t\r]/, "", $0); print $0}')
  else
    echo -n $(ip -o addr show | awk -v atype=${1:-inet} '$2 != "lo" && $3 == atype {gsub(/\/[0-9]+/, "", $4); print $4}')
  fi
  echo "%{$dgrey%}]"
}
local ip_info='$(yspep_my_ip)'

# Show Virtualenv
ZSH_THEME_VIRTUALENV_PREFIX=" V:"
ZSH_THEME_VIRTUALENV_SUFFIX=" "
local venv_info="%{$terminfo[bold]$fg[blue]\$(virtualenv_prompt_info)$reset_color%}"

# Other info, you can override this function in .zshrc
yspep_other_info() {
  # Example: Show the GCE_PROJECT variable in yellow:
  : echo "%{\${GCE_PROJECT:+$fg[yellow] GCE:}\$GCE_PROJECT%}"
}
local other_info='$(yspep_other_info)'

# Prompt format:
#
# PRIVILEGES USER @ MACHINE in DIRECTORY on git:BRANCH STATE [TIME] C:LAST_EXIT_CODE V:VIRTUALENV
# $ COMMAND
#
# For example:
#
# % ys @ ys-mbp in ~/.oh-my-zsh on git:master x [21:47:42] C:0
# $
PROMPT="
%{$dgrey%}[%*]%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n)\
%{$fg[white]%}@%{$fg[green]%}%m$ip_info%{$dgrey%}:%{$reset_color%}\
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
 $exit_code$venv_info$other_info
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"

unset RPROMPT

# vim: set ai ts=2 sts=2 et :
#
