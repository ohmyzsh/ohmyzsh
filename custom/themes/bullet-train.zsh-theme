# README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
#
# In addition, I recommend the
# [Tomorrow Night theme](https://github.com/chriskempson/tomorrow-theme) and, if
# you're using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over
# Terminal.app - it has significantly better color fidelity.

# ------------------------------------------------------------------------------
# CONFIGURATION
# The default configuration, that can be overwrite in your .zshrc file
# ------------------------------------------------------------------------------

VIRTUAL_ENV_DISABLE_PROMPT=true

# Define order and content of prompt
if [ ! -n "${BULLETTRAIN_PROMPT_ORDER+1}" ]; then
  BULLETTRAIN_PROMPT_ORDER=(
    time
    status
    custom
    context
    dir
    screen
    perl
    ruby
    virtualenv
    nvm
    aws
    go
    rust
    elixir
    git
    hg
    cmd_exec_time
  )
fi

# PROMPT
if [ ! -n "${BULLETTRAIN_PROMPT_CHAR+1}" ]; then
  BULLETTRAIN_PROMPT_CHAR="\$"
fi
if [ ! -n "${BULLETTRAIN_PROMPT_ROOT+1}" ]; then
  BULLETTRAIN_PROMPT_ROOT=true
fi
if [ ! -n "${BULLETTRAIN_PROMPT_SEPARATE_LINE+1}" ]; then
  BULLETTRAIN_PROMPT_SEPARATE_LINE=true
fi
if [ ! -n "${BULLETTRAIN_PROMPT_ADD_NEWLINE+1}" ]; then
  BULLETTRAIN_PROMPT_ADD_NEWLINE=true
fi

# STATUS
if [ ! -n "${BULLETTRAIN_STATUS_EXIT_SHOW+1}" ]; then
  BULLETTRAIN_STATUS_EXIT_SHOW=false
fi
if [ ! -n "${BULLETTRAIN_STATUS_BG+1}" ]; then
  BULLETTRAIN_STATUS_BG=green
fi
if [ ! -n "${BULLETTRAIN_STATUS_ERROR_BG+1}" ]; then
  BULLETTRAIN_STATUS_ERROR_BG=red
fi
if [ ! -n "${BULLETTRAIN_STATUS_FG+1}" ]; then
  BULLETTRAIN_STATUS_FG=white
fi

# TIME
if [ ! -n "${BULLETTRAIN_TIME_BG+1}" ]; then
  BULLETTRAIN_TIME_BG=white
fi
if [ ! -n "${BULLETTRAIN_TIME_FG+1}" ]; then
  BULLETTRAIN_TIME_FG=black
fi

# CUSTOM
if [ ! -n "${BULLETTRAIN_CUSTOM_MSG+1}" ]; then
  BULLETTRAIN_CUSTOM_MSG=false
fi
if [ ! -n "${BULLETTRAIN_CUSTOM_BG+1}" ]; then
  BULLETTRAIN_CUSTOM_BG=black
fi
if [ ! -n "${BULLETTRAIN_CUSTOM_FG+1}" ]; then
  BULLETTRAIN_CUSTOM_FG=default
fi

# VIRTUALENV
if [ ! -n "${BULLETTRAIN_VIRTUALENV_BG+1}" ]; then
  BULLETTRAIN_VIRTUALENV_BG=yellow
fi
if [ ! -n "${BULLETTRAIN_VIRTUALENV_FG+1}" ]; then
  BULLETTRAIN_VIRTUALENV_FG=white
fi
if [ ! -n "${BULLETTRAIN_VIRTUALENV_PREFIX+1}" ]; then
  BULLETTRAIN_VIRTUALENV_PREFIX=🐍
fi

# NVM
if [ ! -n "${BULLETTRAIN_NVM_BG+1}" ]; then
  BULLETTRAIN_NVM_BG=green
fi
if [ ! -n "${BULLETTRAIN_NVM_FG+1}" ]; then
  BULLETTRAIN_NVM_FG=white
fi
if [ ! -n "${BULLETTRAIN_NVM_PREFIX+1}" ]; then
  BULLETTRAIN_NVM_PREFIX="⬡ "
fi

# AWS
if [ ! -n "${BULLETTRAIN_AWS_BG+1}" ]; then
  BULLETTRAIN_AWS_BG=yellow
fi
if [ ! -n "${BULLETTRAIN_AWS_FG+1}" ]; then
  BULLETTRAIN_AWS_FG=black
fi
if [ ! -n "${BULLETTRAIN_AWS_PREFIX+1}" ]; then
  BULLETTRAIN_AWS_PREFIX="☁️"
fi

# RUBY
if [ ! -n "${BULLETTRAIN_RUBY_BG+1}" ]; then
  BULLETTRAIN_RUBY_BG=red
fi
if [ ! -n "${BULLETTRAIN_RUBY_FG+1}" ]; then
  BULLETTRAIN_RUBY_FG=white
fi
if [ ! -n "${BULLETTRAIN_RUBY_PREFIX+1}" ]; then
  BULLETTRAIN_RUBY_PREFIX=♦️
fi

# Go
if [ ! -n "${BULLETTRAIN_GO_BG+1}" ]; then
  BULLETTRAIN_GO_BG=cyan
fi
if [ ! -n "${BULLETTRAIN_GO_FG+1}" ]; then
  BULLETTRAIN_GO_FG=white
fi
if [ ! -n "${BULLETTRAIN_GO_PREFIX+1}" ]; then
  BULLETTRAIN_GO_PREFIX="go"
fi

# Rust
if [ ! -n "${BULLETTRAIN_RUST_BG+1}" ]; then
  BULLETTRAIN_RUST_BG=black
fi
if [ ! -n "${BULLETTRAIN_RUST_FG+1}" ]; then
  BULLETTRAIN_RUST_FG=white
fi
if [ ! -n "${BULLETTRAIN_RUST_PREFIX+1}" ]; then
  BULLETTRAIN_RUST_PREFIX="🦀"
fi

# Kubernetes Context
if [ ! -n "${BULLETTRAIN_KCTX_BG+1}" ]; then
  BULLETTRAIN_KCTX_BG=yellow
fi
if [ ! -n "${BULLETTRAIN_KCTX_FG+1}" ]; then
  BULLETTRAIN_KCTX_FG=white
fi
if [ ! -n "${BULLETTRAIN_KCTX_PREFIX+1}" ]; then
  BULLETTRAIN_KCTX_PREFIX="⎈"
fi

# ELIXIR
if [ ! -n "${BULLETTRAIN_ELIXIR_BG+1}" ]; then
  BULLETTRAIN_ELIXIR_BG=magenta
fi
if [ ! -n "${BULLETTRAIN_ELIXIR_FG+1}" ]; then
  BULLETTRAIN_ELIXIR_FG=white
fi
if [ ! -n "${BULLETTRAIN_ELIXIR_PREFIX+1}" ]; then
  BULLETTRAIN_ELIXIR_PREFIX="💧"
fi

# DIR
if [ ! -n "${BULLETTRAIN_DIR_BG+1}" ]; then
  BULLETTRAIN_DIR_BG=blue
fi
if [ ! -n "${BULLETTRAIN_DIR_FG+1}" ]; then
  BULLETTRAIN_DIR_FG=white
fi
if [ ! -n "${BULLETTRAIN_DIR_CONTEXT_SHOW+1}" ]; then
  BULLETTRAIN_DIR_CONTEXT_SHOW=false
fi
if [ ! -n "${BULLETTRAIN_DIR_EXTENDED+1}" ]; then
  BULLETTRAIN_DIR_EXTENDED=1
fi

# GIT
if [ ! -n "${BULLETTRAIN_GIT_COLORIZE_DIRTY+1}" ]; then
  BULLETTRAIN_GIT_COLORIZE_DIRTY=false
fi
if [ ! -n "${BULLETTRAIN_GIT_COLORIZE_DIRTY_FG_COLOR+1}" ]; then
  BULLETTRAIN_GIT_COLORIZE_DIRTY_FG_COLOR=black
fi
if [ ! -n "${BULLETTRAIN_GIT_COLORIZE_DIRTY_BG_COLOR+1}" ]; then
  BULLETTRAIN_GIT_COLORIZE_DIRTY_BG_COLOR=yellow
fi
if [ ! -n "${BULLETTRAIN_GIT_BG+1}" ]; then
  BULLETTRAIN_GIT_BG=white
fi
if [ ! -n "${BULLETTRAIN_GIT_FG+1}" ]; then
  BULLETTRAIN_GIT_FG=black
fi
if [ ! -n "${BULLETTRAIN_GIT_EXTENDED+1}" ]; then
  BULLETTRAIN_GIT_EXTENDED=true
fi
if [ ! -n "${BULLETTRAIN_GIT_PROMPT_CMD+1}" ]; then
  BULLETTRAIN_GIT_PROMPT_CMD="\$(git_prompt_info)"
fi

# PERL
if [ ! -n "${BULLETTRAIN_PERL_BG+1}" ]; then
  BULLETTRAIN_PERL_BG=yellow
fi
if [ ! -n "${BULLETTRAIN_PERL_FG+1}" ]; then
  BULLETTRAIN_PERL_FG=black
fi
if [ ! -n "${BULLETTRAIN_PERL_PREFIX+1}" ]; then
  BULLETTRAIN_PERL_PREFIX=🐪
fi

# CONTEXT
if [ ! -n "${BULLETTRAIN_CONTEXT_BG+1}" ]; then
  BULLETTRAIN_CONTEXT_BG=black
fi
if [ ! -n "${BULLETTRAIN_CONTEXT_FG+1}" ]; then
  BULLETTRAIN_CONTEXT_FG=default
fi
if [ ! -n "${BULLETTRAIN_CONTEXT_HOSTNAME+1}" ]; then
  BULLETTRAIN_CONTEXT_HOSTNAME=%m
fi

# GIT PROMPT
if [ ! -n "${BULLETTRAIN_GIT_PREFIX+1}" ]; then
  ZSH_THEME_GIT_PROMPT_PREFIX="\ue0a0 "
else
  ZSH_THEME_GIT_PROMPT_PREFIX=$BULLETTRAIN_GIT_PREFIX
fi
if [ ! -n "${BULLETTRAIN_GIT_SUFFIX+1}" ]; then
  ZSH_THEME_GIT_PROMPT_SUFFIX=""
else
  ZSH_THEME_GIT_PROMPT_SUFFIX=$BULLETTRAIN_GIT_SUFFIX
fi
if [ ! -n "${BULLETTRAIN_GIT_DIRTY+1}" ]; then
  ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}✘%F{black}"
else
  ZSH_THEME_GIT_PROMPT_DIRTY=$BULLETTRAIN_GIT_DIRTY
fi
if [ ! -n "${BULLETTRAIN_GIT_CLEAN+1}" ]; then
  ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}✔%F{black}"
else
  ZSH_THEME_GIT_PROMPT_CLEAN=$BULLETTRAIN_GIT_CLEAN
fi
if [ ! -n "${BULLETTRAIN_GIT_ADDED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_ADDED=" %F{green}✚%F{black}"
else
  ZSH_THEME_GIT_PROMPT_ADDED=$BULLETTRAIN_GIT_ADDED
fi
if [ ! -n "${BULLETTRAIN_GIT_MODIFIED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_MODIFIED=" %F{blue}✹%F{black}"
else
  ZSH_THEME_GIT_PROMPT_MODIFIED=$BULLETTRAIN_GIT_MODIFIED
fi
if [ ! -n "${BULLETTRAIN_GIT_DELETED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_DELETED=" %F{red}✖%F{black}"
else
  ZSH_THEME_GIT_PROMPT_DELETED=$BULLETTRAIN_GIT_DELETED
fi
if [ ! -n "${BULLETTRAIN_GIT_UNTRACKED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_UNTRACKED=" %F{yellow}✭%F{black}"
else
  ZSH_THEME_GIT_PROMPT_UNTRACKED=$BULLETTRAIN_GIT_UNTRACKED
fi
if [ ! -n "${BULLETTRAIN_GIT_RENAMED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
else
  ZSH_THEME_GIT_PROMPT_RENAMED=$BULLETTRAIN_GIT_RENAMED
fi
if [ ! -n "${BULLETTRAIN_GIT_UNMERGED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
else
  ZSH_THEME_GIT_PROMPT_UNMERGED=$BULLETTRAIN_GIT_UNMERGED
fi
if [ ! -n "${BULLETTRAIN_GIT_AHEAD+1}" ]; then
  ZSH_THEME_GIT_PROMPT_AHEAD=" ⬆"
else
  ZSH_THEME_GIT_PROMPT_AHEAD=$BULLETTRAIN_GIT_AHEAD
fi
if [ ! -n "${BULLETTRAIN_GIT_BEHIND+1}" ]; then
  ZSH_THEME_GIT_PROMPT_BEHIND=" ⬇"
else
  ZSH_THEME_GIT_PROMPT_BEHIND=$BULLETTRAIN_GIT_BEHIND
fi
if [ ! -n "${BULLETTRAIN_GIT_DIVERGED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_DIVERGED=" ⬍"
else
  ZSH_THEME_GIT_PROMPT_DIVERGED=$BULLETTRAIN_GIT_PROMPT_DIVERGED
fi

# SCREEN
if [ ! -n "${BULLETTRAIN_SCREEN_BG+1}" ]; then
  BULLETTRAIN_SCREEN_BG=white
fi
if [ ! -n "${BULLETTRAIN_SCREEN_FG+1}" ]; then
  BULLETTRAIN_SCREEN_FG=black
fi
if [ ! -n "${BULLETTRAIN_SCREEN_PREFIX+1}" ]; then
  BULLETTRAIN_SCREEN_PREFIX="⬗"
fi

# COMMAND EXECUTION TIME
if [ ! -n "${BULLETTRAIN_EXEC_TIME_ELAPSED+1}" ]; then
  BULLETTRAIN_EXEC_TIME_ELAPSED=5
fi
if [ ! -n "${BULLETTRAIN_EXEC_TIME_BG+1}" ]; then
  BULLETTRAIN_EXEC_TIME_BG=yellow
fi
if [ ! -n "${BULLETTRAIN_EXEC_TIME_FG+1}" ]; then
  BULLETTRAIN_EXEC_TIME_FG=black
fi


# ------------------------------------------------------------------------------
# SEGMENT DRAWING
# A few functions to make it easy and re-usable to draw segmented prompts
# ------------------------------------------------------------------------------

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes three arguments, background, foreground and text. All of them can be omitted,
# rendering default background/foreground and no text.
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

# ------------------------------------------------------------------------------
# PROMPT COMPONENTS
# Each component will draw itself, and hide itself if no information needs
# to be shown
# ------------------------------------------------------------------------------

# Context: user@hostname (who am I and where am I)
context() {
  local user="$(whoami)"
  [[ "$user" != "$BULLETTRAIN_CONTEXT_DEFAULT_USER" || -n "$BULLETTRAIN_IS_SSH_CLIENT" ]] && echo -n "${user}@$BULLETTRAIN_CONTEXT_HOSTNAME"
}

prompt_context() {
  local _context="$(context)"
  [[ -n "$_context" ]] && prompt_segment $BULLETTRAIN_CONTEXT_BG $BULLETTRAIN_CONTEXT_FG "$_context"
}

# Based on http://stackoverflow.com/a/32164707/3859566
function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  [[ $D > 0 ]] && printf '%dd' $D
  [[ $H > 0 ]] && printf '%dh' $H
  [[ $M > 0 ]] && printf '%dm' $M
  printf '%ds' $S
}

# Prompt previous command execution time
preexec() {
  cmd_timestamp=`date +%s`
}

precmd() {
  local stop=`date +%s`
  local start=${cmd_timestamp:-$stop}
  let BULLETTRAIN_last_exec_duration=$stop-$start
  cmd_timestamp=''
}

prompt_cmd_exec_time() {
  [ $BULLETTRAIN_last_exec_duration -gt $BULLETTRAIN_EXEC_TIME_ELAPSED ] && prompt_segment $BULLETTRAIN_EXEC_TIME_BG $BULLETTRAIN_EXEC_TIME_FG "$(displaytime $BULLETTRAIN_last_exec_duration)"
}

# Custom
prompt_custom() {
  if [[ $BULLETTRAIN_CUSTOM_MSG == false ]]; then
    return
  fi

  local custom_msg
  eval custom_msg=$BULLETTRAIN_CUSTOM_MSG
  [[ -n "${custom_msg}" ]] && prompt_segment $BULLETTRAIN_CUSTOM_BG $BULLETTRAIN_CUSTOM_FG "${custom_msg}"
}

# Git
prompt_git() {
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" == "1" ]]; then
    return
  fi

  local ref dirty mode repo_path git_prompt
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    if [[ $BULLETTRAIN_GIT_COLORIZE_DIRTY == true && -n $(git status --porcelain --ignore-submodules) ]]; then
      BULLETTRAIN_GIT_BG=$BULLETTRAIN_GIT_COLORIZE_DIRTY_BG_COLOR
      BULLETTRAIN_GIT_FG=$BULLETTRAIN_GIT_COLORIZE_DIRTY_FG_COLOR
    fi
    prompt_segment $BULLETTRAIN_GIT_BG $BULLETTRAIN_GIT_FG

    eval git_prompt=${BULLETTRAIN_GIT_PROMPT_CMD}
    if [[ $BULLETTRAIN_GIT_EXTENDED == true ]]; then
      echo -n ${git_prompt}$(git_prompt_status)
    else
      echo -n ${git_prompt}
    fi
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
      if $(hg st | grep -Eq "^\?"); then
        prompt_segment red black
        st='±'
      elif $(hg st | grep -Eq "^(M|A)"); then
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
  local dir=''
  local _context="$(context)"
  [[ $BULLETTRAIN_DIR_CONTEXT_SHOW == true && -n "$_context" ]] && dir="${dir}${_context}:"

  if [[ $BULLETTRAIN_DIR_EXTENDED == 0 ]]; then
    #short directories
    dir="${dir}%1~"
  elif [[ $BULLETTRAIN_DIR_EXTENDED == 2 ]]; then
    #long directories
    dir="${dir}%0~"
  else
    #medium directories (default case)
    dir="${dir}%4(c:...:)%3c"
  fi

  prompt_segment $BULLETTRAIN_DIR_BG $BULLETTRAIN_DIR_FG $dir
}

# RUBY
# RVM: only shows RUBY info if on a gemset that is not the default one
# RBENV: shows current ruby version active in the shell; also with non-global gemsets if any is active
# CHRUBY: shows current ruby version active in the shell
prompt_ruby() {
  if command -v rvm-prompt > /dev/null 2>&1; then
    prompt_segment $BULLETTRAIN_RUBY_BG $BULLETTRAIN_RUBY_FG $BULLETTRAIN_RUBY_PREFIX" $(rvm-prompt i v g)"
  elif command -v chruby > /dev/null 2>&1; then
    prompt_segment $BULLETTRAIN_RUBY_BG $BULLETTRAIN_RUBY_FG $BULLETTRAIN_RUBY_PREFIX"  $(chruby | sed -n -e 's/ \* //p')"
  elif command -v rbenv > /dev/null 2>&1; then
    current_gemset() {
      echo "$(rbenv gemset active 2&>/dev/null | sed -e 's/ global$//')"
    }

    if [[ -n $(current_gemset) ]]; then
      prompt_segment $BULLETTRAIN_RUBY_BG $BULLETTRAIN_RUBY_FG $BULLETTRAIN_RUBY_PREFIX" $(rbenv version | sed -e 's/ (set.*$//')"@"$(current_gemset)"
    else
      prompt_segment $BULLETTRAIN_RUBY_BG $BULLETTRAIN_RUBY_FG $BULLETTRAIN_RUBY_PREFIX" $(rbenv version | sed -e 's/ (set.*$//')"
    fi
  fi
}

# ELIXIR
prompt_elixir() {
  if command -v elixir > /dev/null 2>&1; then
    prompt_segment $BULLETTRAIN_ELIXIR_BG $BULLETTRAIN_ELIXIR_FG $BULLETTRAIN_ELIXIR_PREFIX" $(elixir -v | tail -n 1 | awk '{print $2}')"
  fi
}

# PERL
# PLENV: shows current PERL version active in the shell
prompt_perl() {
  if command -v plenv > /dev/null 2>&1; then
    prompt_segment $BULLETTRAIN_PERL_BG $BULLETTRAIN_PERL_FG $BULLETTRAIN_PERL_PREFIX" $(plenv version | sed -e 's/ (set.*$//')"
  fi
}

# Go
prompt_go() {
  setopt extended_glob
  if [[ (-f *.go(#qN) || -d Godeps || -f glide.yaml) ]]; then
    if command -v go > /dev/null 2>&1; then
      prompt_segment $BULLETTRAIN_GO_BG $BULLETTRAIN_GO_FG $BULLETTRAIN_GO_PREFIX" $(go version | grep --colour=never -oE '[[:digit:]].[[:digit:]]+')"
    fi
  fi
}

# Rust
prompt_rust() {
  if [[ (-f Cargo.toml) ]]; then
    if command -v rustc > /dev/null 2>&1; then
      prompt_segment $BULLETTRAIN_RUST_BG $BULLETTRAIN_RUST_FG $BULLETTRAIN_RUST_PREFIX" $(rustc -V version | cut -d' ' -f2)"
    fi
  fi
}

# Kubernetes Context
prompt_kctx() {
  if [[ ! -n $BULLETTRAIN_KCTX_KCONFIG ]]; then
    return
  fi
  if command -v kubectl > /dev/null 2>&1; then
    if [[ -f $BULLETTRAIN_KCTX_KCONFIG ]]; then
      prompt_segment $BULLETTRAIN_KCTX_BG $BULLETTRAIN_KCTX_FG $BULLETTRAIN_KCTX_PREFIX" $(cat $BULLETTRAIN_KCTX_KCONFIG|grep current-context| awk '{print $2}')"
    fi  
  fi
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment $BULLETTRAIN_VIRTUALENV_BG $BULLETTRAIN_VIRTUALENV_FG $BULLETTRAIN_VIRTUALENV_PREFIX" $(basename $virtualenv_path)"
  elif which pyenv &> /dev/null; then
    prompt_segment $BULLETTRAIN_VIRTUALENV_BG $BULLETTRAIN_VIRTUALENV_FG $BULLETTRAIN_VIRTUALENV_PREFIX" $(pyenv version | sed -e 's/ (set.*$//' | tr '\n' ' ' | sed 's/.$//')"
  fi
}

# NVM: Node version manager
prompt_nvm() {
  local nvm_prompt
  if type nvm >/dev/null 2>&1; then
    nvm_prompt=$(nvm current 2>/dev/null)
    [[ "${nvm_prompt}x" == "x" ]] && return
  elif type node >/dev/null 2>&1; then
    nvm_prompt="$(node --version)"
  else
    return
  fi
  nvm_prompt=${nvm_prompt}
  prompt_segment $BULLETTRAIN_NVM_BG $BULLETTRAIN_NVM_FG $BULLETTRAIN_NVM_PREFIX$nvm_prompt
}

#AWS Profile
prompt_aws() {
  local spaces="  "

  if [[ -n "$AWS_PROFILE" ]]; then
    prompt_segment $BULLETTRAIN_AWS_BG $BULLETTRAIN_AWS_FG $BULLETTRAIN_AWS_PREFIX$spaces$AWS_PROFILE
  fi
}

# SCREEN Session
prompt_screen() {
  local session_name="$STY"
  if [[ "$session_name" != "" ]]; then
    prompt_segment $BULLETTRAIN_SCREEN_BG $BULLETTRAIN_SCREEN_FG $BULLETTRAIN_SCREEN_PREFIX" $session_name"
  fi
}

prompt_time() {
  if [[ $BULLETTRAIN_TIME_12HR == true ]]; then
    prompt_segment $BULLETTRAIN_TIME_BG $BULLETTRAIN_TIME_FG %D{%r}
  else
    prompt_segment $BULLETTRAIN_TIME_BG $BULLETTRAIN_TIME_FG %D{%T}
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 && $BULLETTRAIN_STATUS_EXIT_SHOW != true ]] && symbols+="✘"
  [[ $RETVAL -ne 0 && $BULLETTRAIN_STATUS_EXIT_SHOW == true ]] && symbols+="✘ $RETVAL"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡%f"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="⚙"

  if [[ -n "$symbols" && $RETVAL -ne 0 ]]; then
    prompt_segment $BULLETTRAIN_STATUS_ERROR_BG $BULLETTRAIN_STATUS_FG "$symbols"
  elif [[ -n "$symbols" ]]; then
    prompt_segment $BULLETTRAIN_STATUS_BG $BULLETTRAIN_STATUS_FG "$symbols"
  fi

}

# Prompt Character
prompt_chars() {
  local bt_prompt_chars="${BULLETTRAIN_PROMPT_CHAR}"

  if [[ $BULLETTRAIN_PROMPT_ROOT == true ]]; then
    bt_prompt_chars="%(!.%F{red}# .%F{green}${bt_prompt_chars}%f)"
  fi

  if [[ $BULLETTRAIN_PROMPT_SEPARATE_LINE == false ]]; then
    bt_prompt_chars="${bt_prompt_chars}"
  fi

  echo -n "$bt_prompt_chars"

  if [[ -n $BULLETTRAIN_PROMPT_CHAR ]]; then
    echo -n " "
  fi
}

# Prompt Line Separator
prompt_line_sep() {
  if [[ $BULLETTRAIN_PROMPT_SEPARATE_LINE == true ]]; then
    # newline wont print without a non newline character, so add a zero-width space
    echo -e '\n%{\u200B%}'
  fi
}

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt() {
  RETVAL=$?
  for segment in $BULLETTRAIN_PROMPT_ORDER
  do
    prompt_$segment
  done
  prompt_end
}

NEWLINE='
'
PROMPT=''
[[ $BULLETTRAIN_PROMPT_ADD_NEWLINE == true ]] && PROMPT="$PROMPT$NEWLINE"
PROMPT="$PROMPT"'%{%f%b%k%}$(build_prompt)'
[[ $BULLETTRAIN_PROMPT_SEPARATE_LINE == true ]] && PROMPT="$PROMPT$NEWLINE"
PROMPT="$PROMPT"'%{${fg_bold[default]}%}'
[[ $BULLETTRAIN_PROMPT_SEPARATE_LINE == false ]] && PROMPT="$PROMPT "
PROMPT="$PROMPT"'$(prompt_chars)%{$reset_color%}'
