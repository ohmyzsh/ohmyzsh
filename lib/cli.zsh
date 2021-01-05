#!/usr/bin/env zsh

function omz {
  [[ $# -gt 0 ]] || {
    _omz::help
    return 1
  }

  local command="$1"
  shift

  # Subcommand functions start with _ so that they don't
  # appear as completion entries when looking for `omz`
  (( $+functions[_omz::$command] )) || {
    _omz::help
    return 1
  }

  _omz::$command "$@"
}

function _omz {
  local -a cmds subcmds
  cmds=(
    'changelog:Print the changelog'
    'help:Usage information'
    'plugin:Manage plugins'
    'pr:Manage Oh My Zsh Pull Requests'
    'theme:Manage themes'
    'update:Update Oh My Zsh'
  )

  if (( CURRENT == 2 )); then
    _describe 'command' cmds
  elif (( CURRENT == 3 )); then
    case "$words[2]" in
      changelog) local -a refs
        refs=("${(@f)$(command git for-each-ref --format="%(refname:short):%(subject)" refs/heads refs/tags)}")
        _describe 'command' refs ;;
      plugin) subcmds=('info:Get plugin information' 'list:List plugins')
        _describe 'command' subcmds ;;
      pr) subcmds=('test:Test a Pull Request' 'clean:Delete all Pull Request branches')
        _describe 'command' subcmds ;;
      theme) subcmds=('use:Load a theme' 'list:List themes')
        _describe 'command' subcmds ;;
    esac
  elif (( CURRENT == 4 )); then
    case "$words[2]::$words[3]" in
      plugin::info) compadd "$ZSH"/plugins/*/README.md(.N:h:t) \
        "$ZSH_CUSTOM"/plugins/*/README.md(.N:h:t) ;;
      theme::use) compadd "$ZSH"/themes/*.zsh-theme(.N:t:r) \
        "$ZSH_CUSTOM"/**/*.zsh-theme(.N:r:gs:"$ZSH_CUSTOM"/themes/:::gs:"$ZSH_CUSTOM"/:::) ;;
    esac
  fi

  return 0
}

compdef _omz omz

## Utility functions

function _omz::confirm {
  # If question supplied, ask it before reading the answer
  # NOTE: uses the logname of the caller function
  if [[ -n "$1" ]]; then
    _omz::log prompt "$1" "${${functrace[1]#_}%:*}"
  fi

  # Read one character
  read -r -k 1

  # If no newline entered, add a newline
  if [[ "$REPLY" != $'\n' ]]; then
    echo
  fi
}

function _omz::log {
  # if promptsubst is set, a message with `` or $()
  # will be run even if quoted due to `print -P`
  setopt localoptions nopromptsubst

  # $1 = info|warn|error|debug
  # $2 = text
  # $3 = (optional) name of the logger

  local logtype=$1
  local logname=${3:-${${functrace[1]#_}%:*}}

  # Don't print anything if debug is not active
  if [[ $logtype = debug && -z $_OMZ_DEBUG ]]; then
    return
  fi

  # Choose coloring based on log type
  case "$logtype" in
    prompt) print -Pn "%S%F{blue}$logname%f%s: $2" ;;
    debug) print -P "%F{white}$logname%f: $2" ;;
    info) print -P "%F{green}$logname%f: $2" ;;
    warn) print -P "%S%F{yellow}$logname%f%s: $2" ;;
    error) print -P "%S%F{red}$logname%f%s: $2" ;;
  esac >&2
}

## User-facing commands

function _omz::help {
  cat <<EOF
Usage: omz <command> [options]

Available commands:

  help                Print this help message
  changelog           Print the changelog
  plugin <command>    Manage plugins
  pr     <command>    Manage Oh My Zsh Pull Requests
  theme  <command>    Manage themes
  update              Update Oh My Zsh

EOF
}

function _omz::changelog {
  local version=${1:-HEAD} format=${3:-"--text"}

  if ! command git -C "$ZSH" show-ref --verify refs/heads/$version &>/dev/null && \
    ! command git -C "$ZSH" show-ref --verify refs/tags/$version &>/dev/null && \
    ! command git -C "$ZSH" rev-parse --verify "${version}^{commit}" &>/dev/null; then
    cat <<EOF
Usage: omz changelog [version]

NOTE: <version> must be a valid branch, tag or commit.
EOF
    return 1
  fi

  "$ZSH/tools/changelog.sh" "$version" "${2:-}" "$format"
}

function _omz::plugin {
  (( $# > 0 && $+functions[_omz::plugin::$1] )) || {
    cat <<EOF
Usage: omz plugin <command> [options]

Available commands:

  info <plugin>   Get information of a plugin
  list            List all available Oh My Zsh plugins

EOF
    return 1
  }

  local command="$1"
  shift

  _omz::plugin::$command "$@"
}

function _omz::plugin::info {
  if [[ -z "$1" ]]; then
    echo >&2 "Usage: omz plugin info <plugin>"
    return 1
  fi

  local readme
  for readme in "$ZSH_CUSTOM/plugins/$1/README.md" "$ZSH/plugins/$1/README.md"; do
    if [[ -f "$readme" ]]; then
      (( ${+commands[less]} )) && less "$readme" || cat "$readme"
      return 0
    fi
  done

  if [[ -d "$ZSH_CUSTOM/plugins/$1" || -d "$ZSH/plugins/$1" ]]; then
    _omz::log error "the '$1' plugin doesn't have a README file"
  else
    _omz::log error "'$1' plugin not found"
  fi

  return 1
}

function _omz::plugin::list {
  local -a custom_plugins builtin_plugins
  custom_plugins=("$ZSH_CUSTOM"/plugins/*(-/N:t))
  builtin_plugins=("$ZSH"/plugins/*(-/N:t))

  # If the command is being piped, print all found line by line
  if [[ ! -t 1 ]]; then
    print -l ${(q-)custom_plugins} ${(q-)builtin_plugins}
    return
  fi

  if (( ${#custom_plugins} )); then
    print -P "%U%BCustom plugins%b%u:"
    print -l ${(q-)custom_plugins} | column
  fi

  if (( ${#builtin_plugins} )); then
    (( ${#custom_plugins} )) && echo # add a line of separation

    print -P "%U%BBuilt-in plugins%b%u:"
    print -l ${(q-)builtin_plugins} | column
  fi
}

function _omz::pr {
  (( $# > 0 && $+functions[_omz::pr::$1] )) || {
    cat <<EOF
Usage: omz pr <command> [options]

Available commands:

  clean                       Delete all PR branches (ohmyzsh/pull-*)
  test <PR_number_or_URL>     Fetch PR #NUMBER and rebase against master

EOF
    return 1
  }

  local command="$1"
  shift

  _omz::pr::$command "$@"
}

function _omz::pr::clean {
  (
    set -e
    builtin cd -q "$ZSH"

    # Check if there are PR branches
    local fmt branches
    fmt="%(color:bold blue)%(align:18,right)%(refname:short)%(end)%(color:reset) %(color:dim bold red)%(objectname:short)%(color:reset) %(color:yellow)%(contents:subject)"
    branches="$(command git for-each-ref --sort=-committerdate --color --format="$fmt" "refs/heads/ohmyzsh/pull-*")"

    # Exit if there are no PR branches
    if [[ -z "$branches" ]]; then
      _omz::log info "there are no Pull Request branches to remove."
      return
    fi

    # Print found PR branches
    echo "$branches\n"
    # Confirm before removing the branches
    _omz::confirm "do you want remove these Pull Request branches? [Y/n] "
    # Only proceed if the answer is a valid yes option
    [[ "$REPLY" != [yY$'\n'] ]] && return

    _omz::log info "removing all Oh My Zsh Pull Request branches..."
    command git branch --list 'ohmyzsh/pull-*' | while read branch; do
      command git branch -D "$branch"
    done
  )
}

function _omz::pr::test {
  # Allow $1 to be a URL to the pull request
  if [[ "$1" = https://* ]]; then
    1="${1:t}"
  fi

  # Check the input
  if ! [[ -n "$1" && "$1" =~ ^[[:digit:]]+$ ]]; then
    echo >&2 "Usage: omz pr test <PR_NUMBER_or_URL>"
    return 1
  fi

  # Save current git HEAD
  local branch
  branch=$(builtin cd -q "$ZSH"; git symbolic-ref --short HEAD) || {
    _omz::log error "error when getting the current git branch. Aborting..."
    return 1
  }


  # Fetch PR onto ohmyzsh/pull-<PR_NUMBER> branch and rebase against master
  # If any of these operations fail, undo the changes made
  (
    set -e
    builtin cd -q "$ZSH"

    # Get the ohmyzsh git remote
    command git remote -v | while read remote url _; do
      case "$url" in
      https://github.com/ohmyzsh/ohmyzsh(|.git)) found=1; break ;;
      git@github.com:ohmyzsh/ohmyzsh(|.git)) found=1; break ;;
      esac
    done

    (( $found )) || {
      _omz::log error "could not found the ohmyzsh git remote. Aborting..."
      return 1
    }

    # Fetch pull request head
    _omz::log info "fetching PR #$1 to ohmyzsh/pull-$1..."
    command git fetch -f "$remote" refs/pull/$1/head:ohmyzsh/pull-$1 || {
      _omz::log error "error when trying to fetch PR #$1."
      return 1
    }

    # Rebase pull request branch against the current master
    _omz::log info "rebasing PR #$1..."
    command git rebase master ohmyzsh/pull-$1 || {
      command git rebase --abort &>/dev/null
      _omz::log warn "could not rebase PR #$1 on top of master."
      _omz::log warn "you might not see the latest stable changes."
      _omz::log info "run \`zsh\` to test the changes."
      return 1
    }

    _omz::log info "fetch of PR #${1} successful."
  )

  # If there was an error, abort running zsh to test the PR
  [[ $? -eq 0 ]] || return 1

  # Run zsh to test the changes
  _omz::log info "running \`zsh\` to test the changes. Run \`exit\` to go back."
  command zsh -l

  # After testing, go back to the previous HEAD if the user wants
  _omz::confirm "do you want to go back to the previous branch? [Y/n] "
  # Only proceed if the answer is a valid yes option
  [[ "$REPLY" != [yY$'\n'] ]] && return

  (
    set -e
    builtin cd -q "$ZSH"

    command git checkout "$branch" -- || {
      _omz::log error "could not go back to the previous branch ('$branch')."
      return 1
    }
  )
}

function _omz::theme {
  (( $# > 0 && $+functions[_omz::theme::$1] )) || {
    cat <<EOF
Usage: omz theme <command> [options]

Available commands:

  list            List all available Oh My Zsh themes
  use <theme>     Load an Oh My Zsh theme

EOF
    return 1
  }

  local command="$1"
  shift

  _omz::theme::$command "$@"
}

function _omz::theme::list {
  local -a custom_themes builtin_themes
  custom_themes=("$ZSH_CUSTOM"/**/*.zsh-theme(-.N:r:gs:"$ZSH_CUSTOM"/themes/:::gs:"$ZSH_CUSTOM"/:::))
  builtin_themes=("$ZSH"/themes/*.zsh-theme(-.N:t:r))

  # If the command is being piped, print all found line by line
  if [[ ! -t 1 ]]; then
    print -l ${(q-)custom_themes} ${(q-)builtin_themes}
    return
  fi

  if (( ${#custom_themes} )); then
    print -P "%U%BCustom themes%b%u:"
    print -l ${(q-)custom_themes} | column
  fi

  if (( ${#builtin_themes} )); then
    (( ${#custom_themes} )) && echo # add a line of separation

    print -P "%U%BBuilt-in themes%b%u:"
    print -l ${(q-)builtin_themes} | column
  fi
}

function _omz::theme::use {
  if [[ -z "$1" ]]; then
    echo >&2 "Usage: omz theme use <theme>"
    return 1
  fi

  # Respect compatibility with old lookup order
  if [[ -f "$ZSH_CUSTOM/$1.zsh-theme" ]]; then
    source "$ZSH_CUSTOM/$1.zsh-theme"
  elif [[ -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]]; then
    source "$ZSH_CUSTOM/themes/$1.zsh-theme"
  elif [[ -f "$ZSH/themes/$1.zsh-theme" ]]; then
    source "$ZSH/themes/$1.zsh-theme"
  else
    _omz::log error "theme '$1' not found"
    return 1
  fi
}

function _omz::update {
  # Run update script
  if [[ "$1" != --unattended ]]; then
    ZSH="$ZSH" zsh -f "$ZSH/tools/upgrade.sh" --interactive
  else
    ZSH="$ZSH" zsh -f "$ZSH/tools/upgrade.sh"
  fi
  local ret=$?

  # Update last updated file
  zmodload zsh/datetime
  echo "LAST_EPOCH=$(( EPOCHSECONDS / 60 / 60 / 24 ))" >! "${ZSH_CACHE_DIR}/.zsh-update"
  # Remove update lock if it exists
  command rm -rf "$ZSH/log/update.lock"

  # Restart the zsh session
  if [[ $ret -eq 0 && "$1" != --unattended ]]; then
    # Old zsh versions don't have ZSH_ARGZERO
    local zsh="${ZSH_ARGZERO:-${functrace[-1]%:*}}"
    # Check whether to run a login shell
    [[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
  fi
}
