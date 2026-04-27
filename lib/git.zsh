autoload -Uz is-at-least

# The git prompt's git commands are read-only and should not interfere with
# other processes. This environment variable is equivalent to running with `git
# --no-optional-locks`, but falls back gracefully for older versions of git.
# See git(1) for and git-status(1) for a description of that flag.
#
# We wrap in a local function instead of exporting the variable directly in
# order to avoid interfering with manually-run git commands by the user.
function __git_prompt_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

function _omz_git_prompt_info() {
  # If we are on a folder not tracked by git, get out.
  # Otherwise, check for hide-info at global and local repository level
  if ! __git_prompt_git rev-parse --git-dir &> /dev/null \
    || [[ "$(__git_prompt_git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]]; then
    return 0
  fi

  # Get either:
  # - the current branch name
  # - the tag name if we are on a tag
  # - the short SHA of the current commit
  local ref
  ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git describe --tags --exact-match HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) \
  || return 0

  # Use global ZSH_THEME_GIT_SHOW_UPSTREAM=1 for including upstream remote info
  local upstream
  if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} )); then
    upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) \
    && upstream=" -> ${upstream}"
  fi

  local escaped_ref="${ref:gs/%/%%}${upstream:gs/%/%%}"
  local dirty="$(parse_git_dirty)"

  # In async context, output ref and dirty indicator separated by Unit Separator
  # (U+001F) so the renderer can assemble the prompt and apply pending-state
  # styling without needing to decompose a pre-formatted string.
  # Check for the specific handler key to avoid false positives when the
  # associative array exists but this handler hasn't been registered.
  if (( ${+_OMZ_ASYNC_PENDING[_omz_git_prompt_info]} )); then
    printf '%s\x1f%s' "$escaped_ref" "$dirty"
  else
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${escaped_ref}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  fi
}

function _omz_git_prompt_status() {
  [[ "$(__git_prompt_git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]] && return

  # Maps a git status prefix to an internal constant
  # This cannot use the prompt constants, as they may be empty
  local -A prefix_constant_map
  prefix_constant_map=(
    '\?\? '     'UNTRACKED'
    'A  '       'ADDED'
    'M  '       'MODIFIED'
    'MM '       'MODIFIED'
    ' M '       'MODIFIED'
    'AM '       'MODIFIED'
    ' T '       'MODIFIED'
    'R  '       'RENAMED'
    ' D '       'DELETED'
    'D  '       'DELETED'
    'UU '       'UNMERGED'
    'ahead'     'AHEAD'
    'behind'    'BEHIND'
    'diverged'  'DIVERGED'
    'stashed'   'STASHED'
  )

  # Maps the internal constant to the prompt theme
  local -A constant_prompt_map
  constant_prompt_map=(
    'UNTRACKED' "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    'ADDED'     "$ZSH_THEME_GIT_PROMPT_ADDED"
    'MODIFIED'  "$ZSH_THEME_GIT_PROMPT_MODIFIED"
    'RENAMED'   "$ZSH_THEME_GIT_PROMPT_RENAMED"
    'DELETED'   "$ZSH_THEME_GIT_PROMPT_DELETED"
    'UNMERGED'  "$ZSH_THEME_GIT_PROMPT_UNMERGED"
    'AHEAD'     "$ZSH_THEME_GIT_PROMPT_AHEAD"
    'BEHIND'    "$ZSH_THEME_GIT_PROMPT_BEHIND"
    'DIVERGED'  "$ZSH_THEME_GIT_PROMPT_DIVERGED"
    'STASHED'   "$ZSH_THEME_GIT_PROMPT_STASHED"
  )

  # The order that the prompt displays should be added to the prompt
  local status_constants
  status_constants=(
    UNTRACKED ADDED MODIFIED RENAMED DELETED
    STASHED UNMERGED AHEAD BEHIND DIVERGED
  )

  local status_text
  status_text="$(__git_prompt_git status --porcelain -b 2> /dev/null)"

  # Don't continue on a catastrophic failure
  if [[ $? -eq 128 ]]; then
    return 1
  fi

  # A lookup table of each git status encountered
  local -A statuses_seen

  if __git_prompt_git rev-parse --verify refs/stash &>/dev/null; then
    statuses_seen[STASHED]=1
  fi

  local status_lines
  status_lines=("${(@f)${status_text}}")

  # If the tracking line exists, get and parse it
  if [[ "$status_lines[1]" =~ "^## [^ ]+ \[(.*)\]" ]]; then
    local branch_statuses
    branch_statuses=("${(@s/,/)match}")
    for branch_status in $branch_statuses; do
      if [[ ! $branch_status =~ "(behind|diverged|ahead) ([0-9]+)?" ]]; then
        continue
      fi
      local last_parsed_status=$prefix_constant_map[$match[1]]
      statuses_seen[$last_parsed_status]=$match[2]
    done
  fi

  # For each status prefix, do a regex comparison
  for status_prefix in "${(@k)prefix_constant_map}"; do
    local status_constant="${prefix_constant_map[$status_prefix]}"
    local status_regex=$'(^|\n)'"$status_prefix"

    if [[ "$status_text" =~ $status_regex ]]; then
      statuses_seen[$status_constant]=1
    fi
  done

  # Display the seen statuses in the order specified
  local status_prompt
  for status_constant in $status_constants; do
    if (( ${+statuses_seen[$status_constant]} )); then
      local next_display=$constant_prompt_map[$status_constant]
      status_prompt="$next_display$status_prompt"
    fi
  done

  echo $status_prompt
}

# Use async version if setting is enabled, or unset but zsh version is at least 5.0.6.
# This avoids async prompt issues caused by previous zsh versions:
# - https://github.com/ohmyzsh/ohmyzsh/issues/12331
# - https://github.com/ohmyzsh/ohmyzsh/issues/12360
# TODO(2024-06-12): @mcornella remove workaround when CentOS 7 reaches EOL

# Helper functions for async pending-state rendering (used by _omz_render_git_prompt_info).

# Detect whether bold is the active terminal state at the end of a prompt string.
# Expands zsh prompt escapes (%B, %b) then parses ANSI SGR sequences in order.
# NOTE: Only standard SGR sequences (\e[...m) are parsed. Non-SGR CSI sequences
# (e.g. cursor movement) in the prefix may cause incorrect results.
function _omz_is_bold_at_end() {
  local expanded=$(print -Pn -- "$1")
  local is_bold=0 remaining="$expanded"
  local params p
  while [[ "$remaining" == *$'\e['*'m'* ]]; do
    remaining="${remaining#*$'\e['}"
    params="${remaining%%m*}"
    remaining="${remaining#*m}"
    # Bare \e[m (empty params) is equivalent to \e[0m (full reset)
    if [[ -z "$params" ]]; then
      is_bold=0
    else
      for p in ${(s/;/)params}; do
        case "$p" in
          0) is_bold=0 ;;
          1|01) is_bold=1 ;;
          22) is_bold=0 ;;
        esac
      done
    fi
  done
  return $(( ! is_bold ))
}

function _omz_render_git_prompt_info() {
  local raw="${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]}"
  [[ -z "$raw" ]] && return

  # Backward compat: if output has no Unit Separator, it's the old single-line format
  if [[ "$raw" != *$'\x1f'* ]]; then
    echo -n "$raw"
    return
  fi

  # Async output is two fields separated by Unit Separator (U+001F): ref and dirty indicator.
  # Assemble the prompt from these parts and the current theme variables.
  local ref="${raw%%$'\x1f'*}"
  local dirty="${raw#*$'\x1f'}"

  if (( _OMZ_ASYNC_PENDING[_omz_git_prompt_info] )); then
    local stale_prefix="${ZSH_THEME_GIT_PROMPT_STALE_PREFIX-}"
    local stale_suffix="${ZSH_THEME_GIT_PROMPT_STALE_SUFFIX-}"

    # If user hasn't set custom stale vars, auto-detect from the theme prefix:
    # only apply unbold/rebold if the ref text would actually be rendered bold.
    # Cache the result keyed on the prefix value to avoid re-parsing SGR on every render.
    if (( ! ${+ZSH_THEME_GIT_PROMPT_STALE_PREFIX} && ! ${+ZSH_THEME_GIT_PROMPT_STALE_SUFFIX} )); then
      if [[ "$ZSH_THEME_GIT_PROMPT_PREFIX" != "$_OMZ_CACHED_BOLD_PREFIX" ]]; then
        typeset -g _OMZ_CACHED_BOLD_PREFIX="$ZSH_THEME_GIT_PROMPT_PREFIX"
        if _omz_is_bold_at_end "$ZSH_THEME_GIT_PROMPT_PREFIX"; then
          typeset -g _OMZ_CACHED_BOLD_RESULT=1
        else
          typeset -g _OMZ_CACHED_BOLD_RESULT=0
        fi
      fi
      if (( _OMZ_CACHED_BOLD_RESULT )); then
        stale_prefix=$'%{\e[22m%}'
        stale_suffix=$'%{\e[1m%}'
      fi
    fi

    echo -n "${ZSH_THEME_GIT_PROMPT_PREFIX}${stale_prefix}${ref}${dirty}${stale_suffix}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  else
    echo -n "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  fi
}

# Async prompt functions — used by both the auto-detect and "force" branches below.
# Overridden with synchronous versions if async is disabled.
function git_prompt_info() {
  _omz_render_git_prompt_info
}

function git_prompt_status() {
  if [[ -n "${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_status]}" ]]; then
    echo -n "${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_status]}"
  fi
}

local _style
if zstyle -t ':omz:alpha:lib:git' async-prompt \
  || { is-at-least 5.0.6 && zstyle -T ':omz:alpha:lib:git' async-prompt }; then
  # Conditionally register the async handler, only if it's needed in $PROMPT
  # or any of the other prompt variables
  function _defer_async_git_register() {
    # Check if git_prompt_info is used in a prompt variable
    case "${PS1}:${PS2}:${PS3}:${PS4}:${RPROMPT}:${RPS1}:${RPS2}:${RPS3}:${RPS4}" in
    *(\$\(git_prompt_info\)|\`git_prompt_info\`)*)
      _omz_register_handler _omz_git_prompt_info
      ;;
    esac

    case "${PS1}:${PS2}:${PS3}:${PS4}:${RPROMPT}:${RPS1}:${RPS2}:${RPS3}:${RPS4}" in
    *(\$\(git_prompt_status\)|\`git_prompt_status\`)*)
      _omz_register_handler _omz_git_prompt_status
      ;;
    esac

    add-zsh-hook -d precmd _defer_async_git_register
    unset -f _defer_async_git_register
  }

  # Register the async handler first. This needs to be done before
  # the async request prompt is run
  precmd_functions=(_defer_async_git_register $precmd_functions)
elif zstyle -s ':omz:alpha:lib:git' async-prompt _style && [[ $_style == "force" ]]; then
  _omz_register_handler _omz_git_prompt_info
  _omz_register_handler _omz_git_prompt_status
else
  function git_prompt_info() {
    _omz_git_prompt_info
  }
  function git_prompt_status() {
    _omz_git_prompt_status
  }
fi

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(__git_prompt_git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-}" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    case "${GIT_STATUS_IGNORE_SUBMODULES:-}" in
      git)
        # let git decide (this respects per-repo config in .gitmodules)
        ;;
      *)
        # if unset: ignore dirty submodules
        # other values are passed to --ignore-submodules
        FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
        ;;
    esac
    STATUS=$(__git_prompt_git status ${FLAGS} 2> /dev/null | tail -n 1)
  fi
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Gets the difference between the local and remote branches
function git_remote_status() {
    local remote ahead behind git_remote_status git_remote_status_detailed
    remote=${$(__git_prompt_git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]]; then
        ahead=$(__git_prompt_git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(__git_prompt_git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

        if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE"
        elif [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}"
        elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
        elif [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
        fi

        if [[ -n $ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX${remote:gs/%/%%}$git_remote_status_detailed$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX"
        fi

        echo $git_remote_status
    fi
}

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# Outputs the name of the previously checked out branch
# Usage example: git pull origin $(git_previous_branch)
# rev-parse --symbolic-full-name @{-1} only prints if it is a branch
function git_previous_branch() {
  local ref
  ref=$(__git_prompt_git rev-parse --quiet --symbolic-full-name @{-1} 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]] || [[ -z $ref ]]; then
    return  # no git repo or non-branch previous ref
  fi
  echo ${ref#refs/heads/}
}

# Gets the number of commits ahead from remote
function git_commits_ahead() {
  if __git_prompt_git rev-parse --git-dir &>/dev/null; then
    local commits="$(__git_prompt_git rev-list --count @{upstream}..HEAD 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$commits$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
    fi
  fi
}

# Gets the number of commits behind remote
function git_commits_behind() {
  if __git_prompt_git rev-parse --git-dir &>/dev/null; then
    local commits="$(__git_prompt_git rev-list --count HEAD..@{upstream} 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo "$ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX$commits$ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX"
    fi
  fi
}

# Outputs if current branch is ahead of remote
function git_prompt_ahead() {
  if [[ -n "$(__git_prompt_git rev-list origin/$(git_current_branch)..HEAD 2> /dev/null)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Outputs if current branch is behind remote
function git_prompt_behind() {
  if [[ -n "$(__git_prompt_git rev-list HEAD..origin/$(git_current_branch) 2> /dev/null)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
}

# Outputs if current branch exists on remote or not
function git_prompt_remote() {
  if [[ -n "$(__git_prompt_git show-ref origin/$(git_current_branch) 2> /dev/null)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS"
  else
    echo "$ZSH_THEME_GIT_PROMPT_REMOTE_MISSING"
  fi
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  local SHA
  SHA=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  local SHA
  SHA=$(__git_prompt_git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Outputs the name of the current user
# Usage example: $(git_current_user_name)
function git_current_user_name() {
  __git_prompt_git config user.name 2>/dev/null
}

# Outputs the email of the current user
# Usage example: $(git_current_user_email)
function git_current_user_email() {
  __git_prompt_git config user.email 2>/dev/null
}

# Output the name of the root directory of the git repository
# Usage example: $(git_repo_name)
function git_repo_name() {
  local repo_path
  if repo_path="$(__git_prompt_git rev-parse --show-toplevel 2>/dev/null)" && [[ -n "$repo_path" ]]; then
    echo ${repo_path:t}
  fi
}
