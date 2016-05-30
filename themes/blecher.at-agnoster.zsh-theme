# vim:ft=zsh ts=2 sw=2 sts=2
# blecher.at Theme - sped up git support and fixed status, based on 
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
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
DIR_COLOR='blue'

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%}"
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
  if [[ "$user" == "root" ]]; then
    DIR_COLOR=red
  fi
 
  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$user@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  gitbranch;	

  if [[ "$GITBRANCH" != "" ]]; then
  prompt_segment green black
  echo -n " ${GITBRANCH}"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment $DIR_COLOR black '%~'
}

# Fast method to get the current branch in git from https://gist.github.com/wolever/6525437
gitbranch() {
	export GITBRANCH=""

	local repo="${_GITBRANCH_LAST_REPO-}"
	local gitdir=""
	[[ ! -z "$repo" ]] && gitdir="$repo/.git"

	# If we don't have a last seen git repo, or we are in a different directory
	if [[ -z "$repo" || "$PWD" != "$repo"* || ! -e "$gitdir" ]]; then
		local cur="$PWD"
		while [[ ! -z "$cur" ]]; do
			if [[ -e "$cur/.git" ]]; then
				repo="$cur"
				gitdir="$cur/.git"
				break
			fi
			cur="${cur%/*}"
		done
	fi
	
	if [[ -z "$gitdir" ]]; then
		unset _GITBRANCH_LAST_REPO
		return 0
	fi

	export _GITBRANCH_LAST_REPO="${repo}"
	local head=""
	local branch=""
	read head < "$gitdir/HEAD"
	case "$head" in
		ref:*)
			branch="${head##*/}"
			;;
		"")
			branch=""
			;;
		*)
			branch="d:${head:0:7}"
			;;
	esac
	if [[ -z "$branch" ]]; then
		return 0
	fi
	export GITBRANCH="$branch"
}
	
# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘ " || symbols+="  "

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_git
  prompt_dir
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
