# Migrate .zsh-update file to $ZSH_CACHE_DIR
if [[ -f ~/.zsh-update && ! -f "${ZSH_CACHE_DIR}/.zsh-update" ]]; then
  mv ~/.zsh-update "${ZSH_CACHE_DIR}/.zsh-update"
fi

# Get user's update preferences
#
# Supported update modes:
# - prompt (default): the user is asked before updating when it's time to update
# - auto: the update is performed automatically when it's time
# - reminder: a reminder is shown to the user when it's time to update
# - background-alpha: an experimental update-on-the-background option
# - disabled: automatic update is turned off
zstyle -s ':omz:update' mode update_mode || {
  update_mode=prompt

  # If the mode zstyle setting is not set, support old-style settings
  [[ "$DISABLE_UPDATE_PROMPT" != true ]] || update_mode=auto
  [[ "$DISABLE_AUTO_UPDATE" != true ]] || update_mode=disabled
}

# Cancel update if:
# - the automatic update is disabled
# - the current user doesn't have write permissions nor owns the $ZSH directory
# - is not run from a tty
# - git is unavailable on the system
# - $ZSH is not a git repository
if [[ "$update_mode" = disabled ]] \
   || [[ ! -w "$ZSH" || ! -O "$ZSH" ]] \
   || [[ ! -t 1 ]] \
   || ! command git --version 2>&1 >/dev/null \
   || (builtin cd -q "$ZSH"; ! command git rev-parse --is-inside-work-tree &>/dev/null); then
  unset update_mode
  return
fi

function current_epoch() {
  zmodload zsh/datetime
  echo $(( EPOCHSECONDS / 60 / 60 / 24 ))
}

function is_update_available() {
  local branch
  branch=${"$(builtin cd -q "$ZSH"; git config --local oh-my-zsh.branch)":-master}

  local remote remote_url remote_repo
  remote=${"$(builtin cd -q "$ZSH"; git config --local oh-my-zsh.remote)":-origin}
  remote_url=$(builtin cd -q "$ZSH"; git config remote.$remote.url)

  local repo
  case "$remote_url" in
  https://github.com/*) repo=${${remote_url#https://github.com/}%.git} ;;
  git@github.com:*) repo=${${remote_url#git@github.com:}%.git} ;;
  *)
    # If the remote is not using GitHub we can't check for updates
    # Let's assume there are updates
    return 0 ;;
  esac

  # If the remote repo is not the official one, let's assume there are updates available
  [[ "$repo" = ohmyzsh/ohmyzsh ]] || return 0
  local api_url="https://api.github.com/repos/${repo}/commits/${branch}"

  # Get local HEAD. If this fails assume there are updates
  local local_head
  local_head=$(builtin cd -q "$ZSH"; git rev-parse $branch 2>/dev/null) || return 0

  # Get remote HEAD. If no suitable command is found assume there are updates
  # On any other error, skip the update (connection may be down)
  local remote_head
  remote_head=$(
    if (( ${+commands[curl]} )); then
      curl --connect-timeout 2 -fsSL -H 'Accept: application/vnd.github.v3.sha' $api_url 2>/dev/null
    elif (( ${+commands[wget]} )); then
      wget -T 2 -O- --header='Accept: application/vnd.github.v3.sha' $api_url 2>/dev/null
    elif (( ${+commands[fetch]} )); then
      HTTP_ACCEPT='Accept: application/vnd.github.v3.sha' fetch -T 2 -o - $api_url 2>/dev/null
    else
      exit 0
    fi
  ) || return 1

  # Compare local and remote HEADs (if they're equal there are no updates)
  [[ "$local_head" != "$remote_head" ]] || return 1

  # If local and remote HEADs don't match, check if there's a common ancestor
  # If the merge-base call fails, $remote_head might not be downloaded so assume there are updates
  local base
  base=$(builtin cd -q "$ZSH"; git merge-base $local_head $remote_head 2>/dev/null) || return 0

  # If the common ancestor ($base) is not $remote_head,
  # the local HEAD is older than the remote HEAD
  [[ $base != $remote_head ]]
}

function update_last_updated_file() {
  local exit_status="$1" error="$2"

  if [[ -z "${1}${2}" ]]; then
    echo "LAST_EPOCH=$(current_epoch)" >! "${ZSH_CACHE_DIR}/.zsh-update"
    return
  fi

  cat >! "${ZSH_CACHE_DIR}/.zsh-update" <<EOD
LAST_EPOCH=$(current_epoch)
EXIT_STATUS=${exit_status}
ERROR='${error//\'/’}'
EOD
}

function update_ohmyzsh() {
  local verbose_mode
  zstyle -s ':omz:update' verbose verbose_mode || verbose_mode=default

  if [[ "$update_mode" != background-alpha ]] \
    && LANG= ZSH="$ZSH" zsh -f "$ZSH/tools/upgrade.sh" -i -v $verbose_mode; then
    update_last_updated_file
    return $?
  fi

  local exit_status error
  if error=$(LANG= ZSH="$ZSH" zsh -f "$ZSH/tools/upgrade.sh" -i -v silent 2>&1); then
    update_last_updated_file 0 "Update successful"
  else
    exit_status=$?
    update_last_updated_file $exit_status "$error"
    return $exit_status
  fi
}

function has_typed_input() {
  # Created by Philippe Troin <phil@fifi.org>
  # https://zsh.org/mla/users/2022/msg00062.html
  emulate -L zsh
  zmodload zsh/zselect

  # Back up stty settings prior to disabling canonical mode
  # Consider that no input can be typed if stty fails
  # (this might happen if stdin is not a terminal)
  local termios
  termios=$(stty --save 2>/dev/null) || return 1
  {
    # Disable canonical mode so that typed input counts
    # regardless of whether Enter was pressed
    stty -icanon

    # Poll stdin (fd 0) for data ready to be read
    zselect -t 0 -r 0
    return $?
  } always {
    # Restore stty settings
    stty $termios
  }
}

function handle_update() {
  () {
    emulate -L zsh

    local epoch_target mtime option LAST_EPOCH

    # Remove lock directory if older than a day
    zmodload zsh/datetime
    zmodload -F zsh/stat b:zstat
    if mtime=$(zstat +mtime "$ZSH/log/update.lock" 2>/dev/null); then
      if (( (mtime + 3600 * 24) < EPOCHSECONDS )); then
        command rm -rf "$ZSH/log/update.lock"
      fi
    fi

    # Check for lock directory
    if ! command mkdir "$ZSH/log/update.lock" 2>/dev/null; then
      return
    fi

    # Remove lock directory on exit. `return $ret` is important for when trapping a SIGINT:
    #  The return status from the function is handled specially. If it is zero, the signal is
    #  assumed to have been handled, and execution continues normally. Otherwise, the shell
    #  will behave as interrupted except that the return status of the trap is retained.
    #  This means that for a CTRL+C, the trap needs to return the same exit status so that
    #  the shell actually exits what it's running.
    trap "
      ret=\$?
      unset update_mode
      unset -f current_epoch is_update_available update_last_updated_file update_ohmyzsh handle_update 2>/dev/null
      command rm -rf '$ZSH/log/update.lock'
      return \$ret
    " EXIT INT QUIT

    # Create or update .zsh-update file if missing or malformed
    if ! source "${ZSH_CACHE_DIR}/.zsh-update" 2>/dev/null || [[ -z "$LAST_EPOCH" ]]; then
      update_last_updated_file
      return
    fi

    # Number of days before trying to update again
    zstyle -s ':omz:update' frequency epoch_target || epoch_target=${UPDATE_ZSH_DAYS:-13}
    # Test if enough time has passed until the next update
    if (( ( $(current_epoch) - $LAST_EPOCH ) < $epoch_target )); then
      return
    fi

    # Test if Oh My Zsh directory is a git repository
    if ! (builtin cd -q "$ZSH" && LANG= git rev-parse &>/dev/null); then
      echo >&2 "[oh-my-zsh] Can't update: not a git repository."
      return
    fi

    # Check if there are updates available before proceeding
    if ! is_update_available; then
      update_last_updated_file
      return
    fi

    # If in reminder mode or user has typed input, show reminder and exit
    if [[ "$update_mode" = reminder ]] || { [[ "$update_mode" != background-alpha ]] && has_typed_input }; then
      printf '\r\e[0K' # move cursor to first column and clear whole line
      echo "[oh-my-zsh] It's time to update! You can do that by running \`omz update\`"
      return 0
    fi

    # Don't ask for confirmation before updating if in auto mode
    if [[ "$update_mode" = (auto|background-alpha) ]]; then
      update_ohmyzsh
      return $?
    fi

    # Ask for confirmation and only update on 'y', 'Y' or Enter
    # Otherwise just show a reminder for how to update
    echo -n "[oh-my-zsh] Would you like to update? [Y/n] "
    read -r -k 1 option
    [[ "$option" = $'\n' ]] || echo
    case "$option" in
      [yY$'\n']) update_ohmyzsh ;;
      [nN]) update_last_updated_file ;&
      *) echo "[oh-my-zsh] You can update manually by running \`omz update\`" ;;
    esac
  }

  unset update_mode
  unset -f current_epoch is_update_available update_last_updated_file update_ohmyzsh handle_update
}

case "$update_mode" in
  background-alpha)
    autoload -Uz add-zsh-hook

    _omz_bg_update() {
      # do the update in a subshell
      (handle_update) &|

      # register update results function
      add-zsh-hook precmd _omz_bg_update_status

      # deregister background function
      add-zsh-hook -d precmd _omz_bg_update
      unset -f _omz_bg_update
    }

    _omz_bg_update_status() {
      {
        local LAST_EPOCH EXIT_STATUS ERROR
        if [[ ! -f "$ZSH_CACHE_DIR"/.zsh-update ]]; then
          return 1
        fi

        # check update results until timeout is reached
        . "$ZSH_CACHE_DIR/.zsh-update"
        if [[ -z "$EXIT_STATUS" || -z "$ERROR" ]]; then
          return 1
        fi

        if [[ "$EXIT_STATUS" -eq 0 ]]; then
          print -P "\n%F{green}[oh-my-zsh] Update successful.%f"
          return 0
        elif [[ "$EXIT_STATUS" -ne 0 ]]; then
          print -P "\n%F{red}[oh-my-zsh] There was an error updating:%f"
          printf "\n${fg[yellow]}%s${reset_color}" "$ERROR"
          return 0
        fi
      } always {
        if (( TRY_BLOCK_ERROR == 0 )); then
          # if last update results have been handled, remove them from the status file
          update_last_updated_file

          # deregister background function
          add-zsh-hook -d precmd _omz_bg_update_status
          unset -f _omz_bg_update_status
        fi
      }
    }

    add-zsh-hook precmd _omz_bg_update
    ;;
  *)
    handle_update ;;
esac
