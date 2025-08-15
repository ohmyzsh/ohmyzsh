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
  local branch=$(fossil branch current 2>&1)

  # if we're not in a fossil repo, don't show anything
  ! command grep -q "use --repo" <<< "$branch" || return

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
  if [ -z "$_FOSSIL_PROMPT" ]; then
    # Use substitutions to work out what other plugins and themes have
    # done ahead of us so we don't duplicate their work.
    #
    # If $fossil_prompt_info isn't in the prompt strings already but we
    # can find $git_prompt_info, put it immediately afterward so that
    # one or the other appears in the prompt.  We're gambling that you
    # aren't in a directory that's a checkout for both a Git repo and a
    # Fossil repo.
    #
    # Otherwise, don't guess about where the user wants our prompt info
    # placed.  They can edit their theme to place it manually.
    if [ "${PROMPT/fossil_prompt_info//}" = "$PROMPT" ]; then
      PROMPT="${PROMPT/git_prompt_info/git_prompt_info)\$(fossil_prompt_info}"
    fi
    if [ "${RPROMPT/fossil_prompt_info//}" = "$RPROMPT" ]; then
      RPROMPT="${RPROMPT/git_prompt_info/git_prompt_info)\$(fossil_prompt_info}"
    fi

    _FOSSIL_PROMPT="1"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd _fossil_prompt
