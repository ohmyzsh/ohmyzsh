_FOSSIL_PROMPT=""

# Prefix at the very beginning of the prompt, before the branch name
ZSH_THEME_FOSSIL_PROMPT_PREFIX="%{$fg_bold[blue]%}fossil:(%{$fg_bold[red]%}"

# At the very end of the prompt
ZSH_THEME_FOSSIL_PROMPT_SUFFIX="%{$fg_bold[blue]%})"

# Text to display if the branch is dirty
ZSH_THEME_FOSSIL_PROMPT_DIRTY=" %{$fg_bold[red]%}✖"

# Text to display if the branch is clean
ZSH_THEME_FOSSIL_PROMPT_CLEAN=" %{$fg_bold[green]%}✔"

function fossil_prompt_info() {
  local info=$(fossil branch 2>&1)

  # if we're not in a fossil repo, don't show anything
  ! command grep -q "use --repo" <<< "$info" || return

  local branch=$(echo $info | grep "* " | sed 's/* //g')
  local changes=$(fossil changes)
  local dirty="$ZSH_THEME_FOSSIL_PROMPT_CLEAN"

  if [[ -n "$changes" ]]; then
    dirty="$ZSH_THEME_FOSSIL_PROMPT_DIRTY"
  fi

  printf '%s %s %s %s %s' \
    "$ZSH_THEME_FOSSIL_PROMPT_PREFIX" \
    "${branch:gs/%/%%}" \
    "$ZSH_THEME_FOSSIL_PROMPT_SUFFIX" \
    "$dirty" \
    "%{$reset_color%}"
}

function _fossil_prompt () {
  local current=`echo $PROMPT $RPROMPT | grep fossil`

  if [ "$_FOSSIL_PROMPT" = "" -o "$current" = "" ]; then
    local _prompt=${PROMPT}
    local _rprompt=${RPROMPT}

    local is_prompt=`echo $PROMPT | grep git`

    if [ "$is_prompt" = "" ]; then
      RPROMPT="$_rprompt"'$(fossil_prompt_info)'
    else
      PROMPT="$_prompt"'$(fossil_prompt_info) '
    fi

    _FOSSIL_PROMPT="1"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd _fossil_prompt
