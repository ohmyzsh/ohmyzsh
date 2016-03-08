# vim:ft=zsh ts=2 sw=2 sts=2
#
# Ciacho Theme 
# Based on agnoster theme
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.


CIACHO_VERSION="0.2"


### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
PRIMARY_FG=black

#SEGMENT_SEPARATOR=" "
SEGMENT_SEPARATOR="\ue0b0"

PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
BRANCH_BEGIN="‹"
BRANCH_END="›"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"


# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

function prompt_ciacho_battery() {
 local symbols
symbols=()
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
			symbols+="$LIGHTNING %{%F{$color}%}[$(battery_pct_remaining)%%]%}"
	  	prompt_segment red default "$symbols"
		fi
	fi
}



function prompt_ciacho_status() {
  local symbols
  symbols=()
  [[ $UID -eq 0 ]] && symbols+="%{%F{red}%}[ROOT]"
  [[ $LANG == "pl_PL.UTF-8" ]] && symbols+="%{%F{green}%}[UTF]"
  [[ $LANG == "pl_PL" ]] && symbols+="%{%F{green}%}[ISO]"
  [[ -n $SSH_CLIENT ]] && symbols+="%{%F{cyan}[SSH]"
  [[ -f /etc/vps ]] && symbols+="%{%F{yellow}[VPS]"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols "
}

prompt_ciacho_git() {
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color=yellow
      ref="${ref} $PLUSMINUS"
    else
      color=green
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH_BEGIN $BRANCH $ref $BRANCH_END"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    prompt_segment $color $PRIMARY_FG
    print -Pn " $ref"
  fi
}

# Dir: current working directory
prompt_ciacho_dir() {
  prompt_segment blue $PRIMARY_FG ' %~'
}


# Context: user@hostname (who am I and where am I)
prompt_ciacho_context() {
	local uid_color
  local host_color

  if [[ $(whoami) == root ]]; then
		# red @ cyan 
		uid_color=red
		host_color=white
	elif [[ $(uname) == Darwin ]]; then
		uid_color=cyan
		host_color=cyan
	elif [[ $(uname) == Darwin && $(whoami) == root ]]; then
		uid_color=red
		host_color=cyan
	else
		uid_color=white
		host_color=white
	fi
   prompt_segment black default "%(!.%{%F{$uid_color}%}.)$USER%(!.%{%F{white}%}.)@%(!.%{%F{$host_color}%}.)%m"
 
}

prompt_ciacho_hash() {
	if [[ $(whoami) == root ]]; then
		prompt_segment red $PRIMARY_FG "\n %#"
  else 
		prompt_segment blue $PRIMARY_FG "\n %#" 
	fi
}

prompt_ciacho_main() {
	RETVAL=$?
	prompt_ciacho_status
	prompt_ciacho_battery
	prompt_ciacho_context
  prompt_ciacho_git
  prompt_ciacho_dir
  prompt_end
  prompt_ciacho_hash
  prompt_end

}


prompt_ciacho_precmd() {
  vcs_info
  PROMPT='%{%f%b%k%}$(prompt_ciacho_main) '
}


prompt_ciacho_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_ciacho_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes false
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_ciacho_setup "$@"


