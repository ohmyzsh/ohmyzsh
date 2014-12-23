# vim:ft=zsh ts=2 sw=2 sts=2
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


### Theme Configuration Initialization
#
# Override these settings in your ~/.zshrc

# Current working directory
: ${AGNOSTER_DIR_FG:=black}
: ${AGNOSTER_DIR_BG:=blue}

# user@host
: ${AGNOSTER_CONTEXT_FG:=default}
: ${AGNOSTER_CONTEXT_BG:=black}

# Git related
: ${AGNOSTER_GIT_CLEAN_FG:=black}
: ${AGNOSTER_GIT_CLEAN_BG:=green}
: ${AGNOSTER_GIT_DIRTY_FG:=black}
: ${AGNOSTER_GIT_DIRTY_BG:=yellow}

# Mercurial related
: ${AGNOSTER_HG_NEWFILE_FG:=white}
: ${AGNOSTER_HG_NEWFILE_BG:=red}
: ${AGNOSTER_HG_CHANGED_FG:=black}
: ${AGNOSTER_HG_CHANGED_BG:=yellow}
: ${AGNOSTER_HG_CLEAN_FG:=black}
: ${AGNOSTER_HG_CLEAN_BG:=green}

# VirtualEnv colors
: ${AGNOSTER_VENV_FG:=black}
: ${AGNOSTER_VENV_BG:=blue}

# Status symbols
: ${AGNOSTER_STATUS_RETVAL_FG:=red}
: ${AGNOSTER_STATUS_ROOT_FG:=yellow}
: ${AGNOSTER_STATUS_JOB_FG:=cyan}
: ${AGNOSTER_STATUS_BG:=black}

## Non-Color settings - set to 'true' to enable
# Show the actual numeric return value rather than a cross symbol.
: ${AGNOSTER_STATUS_RETVAL_NUMERIC:=false}
# Show git working dir in the style "/git/root   master  relative/dir" instead of "/git/root/relative/dir   master"
: ${AGNOSTER_GIT_INLINE:=false}


### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

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
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment "$AGNOSTER_CONTEXT_BG" "$AGNOSTER_CONTEXT_FG" "%(!.%{%F{yellow}%}.)$USER@%m"
  fi
}

prompt_git_relative() {
  local repo_root=$(git rev-parse --show-toplevel)
  local path_in_repo=$(pwd | sed "s/^$(echo "$repo_root" | sed 's:/:\\/:g;s/\$/\\$/g')//;s:^/::;s:/$::;")
  if [[ $path_in_repo != '' ]]; then
    prompt_segment "$AGNOSTER_DIR_BG" "$AGNOSTER_DIR_FG" "$path_in_repo"
  fi;
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment "$AGNOSTER_GIT_DIRTY_BG" "$AGNOSTER_GIT_DIRTY_FG"
    else
      prompt_segment "$AGNOSTER_GIT_CLEAN_BG" "$AGNOSTER_GIT_CLEAN_FG"
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
    [[ $AGNOSTER_GIT_INLINE == 'true' ]] && prompt_git_relative
  fi
}

prompt_hg() {
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment "$AGNOSTER_HG_NEWFILE_BG" "$AGNOSTER_HG_NEWFILE_FG"
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment "$AGNOSTER_HG_CHANGED_BG" "$AGNOSTER_HG_CHANGED_FG"
        st='±'
      else
        # if working copy is clean
        prompt_segment "$AGNOSTER_HG_CLEAN_BG" "$AGNOSTER_HG_CLEAN_FG"
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
        prompt_segment "$AGNOSTER_HG_NEWFILE_BG" "$AGNOSTER_HG_NEWFILE_FG"
        st='±'
      elif `hg st | grep -q "^(M|A)"`; then
        prompt_segment "$AGNOSTER_HG_CHANGED_BG" "$AGNOSTER_HG_CHANGED_FG"
        st='±'
      else
        prompt_segment "$AGNOSTER_HG_CLEAN_BG" "$AGNOSTER_HG_CLEAN_FG"
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  if [[ $AGNOSTER_GIT_INLINE == 'true' ]] && $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    # Git repo and inline path enabled, hence only show the git root
    prompt_segment "$AGNOSTER_DIR_BG" "$AGNOSTER_DIR_FG" "$(git rev-parse --show-toplevel | sed "s:^$HOME:~:")"
  else
    prompt_segment "$AGNOSTER_DIR_BG" "$AGNOSTER_DIR_FG" '%~'
  fi
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment "$AGNOSTER_VENV_BG" "$AGNOSTER_VENV_FG" "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  if [[ $AGNOSTER_STATUS_RETVAL_NUMERIC == 'true' ]]; then
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{$AGNOSTER_STATUS_RETVAL_FG}%}$RETVAL"
  else
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{$AGNOSTER_STATUS_RETVAL_FG}%}✘"
  fi
  [[ $UID -eq 0 ]] && symbols+="%{%F{$AGNOSTER_STATUS_ROOT_FG}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{$AGNOSTER_STATUS_JOB_FG}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment "$AGNOSTER_STATUS_BG" default "$symbols"
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

PROMPT='%{%f%b%k%}$(build_prompt) '
