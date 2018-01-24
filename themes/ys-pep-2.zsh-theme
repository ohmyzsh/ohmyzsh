# ys-pep Theme version 2, based on ys Theme by Yad Smood
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
#
# Changes to ys-pep theme:
#   * Split the prompt definition to 3 sections for better maintainability
#   * Add "leftbar" to more easily identify the prompt after a monstrous scroll
#   * Better IP address detection -- skips link-local, loopback, and DOWN ifaces
#
# Nov-Dec 2017 Pandu POLUAN <pepoluan@gmail.com>

# VCS
YS_VCS_PROMPT_PREFIX1=" %F{white}on%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%F{cyan}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %F{red}x"
YS_VCS_PROMPT_CLEAN=" %F{green}o"

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

local exit_code="%(?,,C:%F{red}%?%{$reset_color%} )"

### BEGIN: pepoluan changes ###
local dgrey="%B%F{black}"
local leftbar1="%F{148}┏%f"
local leftbar2="%F{148}┃%f"
local leftbar3="%F{148}┗%f"

# Show my IP Address
ZSH_THEME_SHOW_IP=1
yspep_my_ip() {
  [[ $ZSH_THEME_SHOW_IP != 1 ]] && return
  echo -n "${dgrey}[%b%F{green}"
  if [[ ${(L)_system_name} == cygwin ]]; then
    echo -n $(ipconfig | awk '$1 ~ /IP/ && $2 ~ /[Aa]ddress/ {sub(/.*:/, "", $0); gsub(/[ \t\r]/, "", $0); print $0}')
  else
    echo -n $(
      while read num dev etc; do
        dev="${dev:0: -1}"  # Remove trailing colon
        dev="${dev//@*/}"   # Remove "@xxx" prefix
        ip -d -o addr sh ${dev} |
          awk '$3 == "inet" {sub(/\/[0-9]+/, "", $4); print "%F{022}"$2":%F{green}"$4}';
      done <<<"$(
        ip -d -o link sh |
          sed -r -e '/link\/loopback/d' -e '/state DOWN/d'
        )"
    )
    # echo -n $(ip -o addr show | awk -v atype=${1:-inet} '$2 != "lo" && $3 == atype {gsub(/\/[0-9]+/, "", $4); print $4}')
  fi
  echo "${dgrey}]%b"
}
local ip_info='$(yspep_my_ip)'

# Show Virtualenv
ZSH_THEME_VIRTUALENV_PREFIX=" V:"
ZSH_THEME_VIRTUALENV_SUFFIX=" "
local venv_info="%B%F{blue}\$(virtualenv_prompt_info)%b"

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

# First Line (notice the newline!)
PROMPT="$leftbar1$ip_info
"

# Second Line (notice the newline!)
PROMPT+="$leftbar2${dgrey}[%*]%b \
%(#,%K{yellow}%F{black}%n%k,%F{cyan}%n)\
%F{white}@%F{green}%m$dgrey:%b\
%B%F{yellow}%~%b\
${hg_info}\
${git_info}\
 $exit_code$venv_info$other_info
"

# Third Line (NO newline!)
PROMPT+="$leftbar3%B%F{red}%#%b%f "

unset RPROMPT

# vim: set ai ts=2 sts=2 et ft=sh :
#
