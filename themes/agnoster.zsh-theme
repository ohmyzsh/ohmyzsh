### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG=''
SEGMENT_SEPARATOR='⮀'
function segment_start() {
  local bg=$1
  local fg=$2
  if [[ -n $CURRENT_BG && $bg != $CURRENT_BG ]]; then
    echo -n " %{%K{$bg}%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%K{$bg}%}"
  fi
  [[ -n $fg ]] && fg="%F{$fg}" || fg="%f"
  echo -n "%{$fg%} "
  CURRENT_BG=$bg
}

function segment_stop() {
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

function prompt_context() {
  local user=`whoami`

  if [[ ("$user" != "$DEFAULT_USER") || (-n "$SSH_CLIENT") ]]; then
    segment_start black
    #echo -n "%{%F{yellow}%}$user%{%F{gray}%}@%{%F{green}%}%m%{%f%}"
    echo -n "%(!.%{%F{yellow}%}.)$user@%m"
  fi
}

function prompt_git() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    local dirty=$(parse_git_dirty)
    local ref
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      segment_start yellow black
    else
      segment_start green black
    fi
    echo -n "${ref/refs\/heads\//⭠ }$dirty"
  fi
}

function prompt_dir() {
  segment_start blue white
  echo -n '%~'
}

function prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  jobs=$(jobs -l | wc -l)
  [[ $jobs -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"
  if [[ -n "$symbols" ]]; then
    segment_start black white
    echo -n "${symbols}"
  fi
}

## Main prompt
function build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  segment_stop
}

PROMPT='%{%f%b%k%}
$(build_prompt) '
