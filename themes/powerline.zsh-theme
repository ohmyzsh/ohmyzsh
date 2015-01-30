# vim:ft=zsh ts=2 sw=2 sts=2
#
# powerline theme - based on agnoster's theme - https://gist.github.com/3712874
#
# I was not satisfied with the agnoster colours so I created my own powerline zsh theme based on the powerline bash
# colour codes.
# --- Armin <netzverweigerer@github>
# 
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
#

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''
RSEGMENT_SEPARATOR=''

# use custom colours:
source "$ZSH"/lib/powerlinecolours

# Begin left side segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# Begin right side segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_rsegment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$RSEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# right side seperator
prompt_rseperator() {
  local bg fg
###  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  echo -n "%{$bg%}%{$fg%}$RSEGMENT_SEPARATOR"
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
# TODO: check if $SSH_CLIENT is set and adjust prompt to include hostname of machine
# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user="$(whoami)"
  if [[ "$user" == "root" ]]; then
    # prompt for root
	  prompt_segment "$prompt_context_root_bg" "$prompt_context_root_fg" "%(!.%{%F{red}%}.)$user"
  else
    # prompt for normal user
	  prompt_segment "$prompt_context_user_bg" "$prompt_context_user_fg" "%(!.%{%F{yellow}%}.)$user"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:git:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\// }${vcs_info_msg_0_%% }${mode}"
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
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment 238 grey '%~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

## left prompt
build_prompt() {
  RETVAL=$?
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_git
  prompt_hg
  prompt_end
}

## right prompt
build_rprompt() {
  RETVAL=$?
  local symbols
  symbols=()
  drawrightprompt=0
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙" && drawrightprompt=1
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡" && drawrightprompt=1
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘ $RETVAL" && drawrightprompt=1
  if [[ "$drawrightprompt" -eq 1 ]]; then
		prompt_rseperator %k 238
  fi
  [[ -n "$symbols" ]] && prompt_segment 236 default "$symbols"
}

PROMPT='%{%f%b%k%}$(build_prompt) '
RPROMPT='%{%f%r%k%}$(build_rprompt) '


<<<<<<< HEAD

=======
>>>>>>> 0166395a0ca78d2d253a3f38272d6542bdf2efda
