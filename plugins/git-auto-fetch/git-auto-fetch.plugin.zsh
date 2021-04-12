# Default auto-fetch interval: 60 seconds
: ${GIT_AUTO_FETCH_INTERVAL:=60}

# Necessary for the git-fetch-all function
zmodload zsh/datetime zsh/stat

function git-fetch-all {
  (
    # Get git root directory
    if ! gitdir="$(command git rev-parse --git-dir 2>/dev/null)"; then
      return 0
    fi

    # Do nothing if auto-fetch disabled
    if [[ -z "$gitdir" || -f "$gitdir/NO_AUTO_FETCH" ]]; then
      return 0
    fi

    # Get time (seconds) when auto-fetch was last run
    lastrun="$(zstat +mtime "$gitdir/FETCH_LOG" 2>/dev/null || echo 0)"
    # Do nothing if not enough time has passed since last auto-fetch
    if (( EPOCHSECONDS - lastrun < $GIT_AUTO_FETCH_INTERVAL )); then
      return 0
    fi

    # Fetch all remotes (avoid ssh passphrase prompt)
    GIT_SSH_COMMAND="command ssh -o BatchMode=yes" \
      command git fetch --all 2>/dev/null &>! "$gitdir/FETCH_LOG"
  ) &|
}

function git-auto-fetch {
  # Do nothing if not in a git repository
  command git rev-parse --is-inside-work-tree &>/dev/null || return 0

  # Remove or create guard file depending on its existence
  local guard="$(command git rev-parse --git-dir)/NO_AUTO_FETCH"
  if [[ -f "$guard" ]]; then
    command rm "$guard" && echo "${fg_bold[green]}enabled${reset_color}"
  else
    command touch "$guard" && echo "${fg_bold[red]}disabled${reset_color}"
  fi
}

# zle-line-init widget (don't redefine if already defined)
(( ! ${+functions[_git-auto-fetch_zle-line-init]} )) || return 0

case "$widgets[zle-line-init]" in
  # Simply define the function if zle-line-init doesn't yet exist
  builtin|"") function _git-auto-fetch_zle-line-init() {
      git-fetch-all
    } ;;
  # Override the current zle-line-init widget, calling the old one
  user:*) zle -N _git-auto-fetch_orig_zle-line-init "${widgets[zle-line-init]#user:}"
    function _git-auto-fetch_zle-line-init() {
      git-fetch-all
      zle _git-auto-fetch_orig_zle-line-init -- "$@"
    } ;;
esac

zle -N zle-line-init _git-auto-fetch_zle-line-init
