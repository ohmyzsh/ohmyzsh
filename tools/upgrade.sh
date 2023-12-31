#!/usr/bin/env zsh
set +u # disable nounset

local ret=0 # exit code

# Protect against running with shells other than zsh
if [ -z "$ZSH_VERSION" ]; then
  exec zsh "$0" "$@"
fi

# Protect against unwanted sourcing
case "$ZSH_EVAL_CONTEXT" in
  *:file) echo "error: this file should not be sourced" && return ;;
esac

cd "$ZSH"

verbose_mode="default"
interactive=false

while getopts "v:i" opt; do
  case $opt in
    v)
      if [[ $OPTARG == default || $OPTARG == minimal || $OPTARG == silent ]]; then
        verbose_mode=$OPTARG
      else
        echo "[oh-my-zsh] update verbosity '$OPTARG' is not valid"
        echo "[oh-my-zsh] valid options are 'default', 'minimal' and 'silent'"
      fi
      ;;
    i) interactive=true ;;
  esac
done

# Use colors, but only if connected to a terminal
# and that terminal supports them.

# The [ -t 1 ] check only works when the function is not called from
# a subshell (like in `$(...)` or `(...)`, so this hack redefines the
# function at the top level to always return false when stdout is not
# a tty.
if [ -t 1 ]; then
  is_tty() {
    true
  }
else
  is_tty() {
    false
  }
fi

# This function uses the logic from supports-hyperlinks[1][2], which is
# made by Kat Marchán (@zkat) and licensed under the Apache License 2.0.
# [1] https://github.com/zkat/supports-hyperlinks
# [2] https://crates.io/crates/supports-hyperlinks
#
# Copyright (c) 2021 Kat Marchán
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
supports_hyperlinks() {
  # $FORCE_HYPERLINK must be set and be non-zero (this acts as a logic bypass)
  if [ -n "$FORCE_HYPERLINK" ]; then
    [ "$FORCE_HYPERLINK" != 0 ]
    return $?
  fi

  # If stdout is not a tty, it doesn't support hyperlinks
  is_tty || return 1

  # DomTerm terminal emulator (domterm.org)
  if [ -n "$DOMTERM" ]; then
    return 0
  fi

  # VTE-based terminals above v0.50 (Gnome Terminal, Guake, ROXTerm, etc)
  if [ -n "$VTE_VERSION" ]; then
    [ $VTE_VERSION -ge 5000 ]
    return $?
  fi

  # If $TERM_PROGRAM is set, these terminals support hyperlinks
  case "$TERM_PROGRAM" in
  Hyper|iTerm.app|terminology|WezTerm) return 0 ;;
  esac

  # kitty supports hyperlinks
  if [ "$TERM" = xterm-kitty ]; then
    return 0
  fi

  # Windows Terminal also supports hyperlinks
  if [ -n "$WT_SESSION" ]; then
    return 0
  fi

  # Konsole supports hyperlinks, but it's an opt-in setting that can't be detected
  # https://github.com/ohmyzsh/ohmyzsh/issues/10964
  # if [ -n "$KONSOLE_VERSION" ]; then
  #   return 0
  # fi

  return 1
}

# Adapted from code and information by Anton Kochkov (@XVilka)
# Source: https://gist.github.com/XVilka/8346728
supports_truecolor() {
  case "$COLORTERM" in
  truecolor|24bit) return 0 ;;
  esac

  case "$TERM" in
  iterm           |\
  tmux-truecolor  |\
  linux-truecolor |\
  xterm-truecolor |\
  screen-truecolor) return 0 ;;
  esac

  return 1
}

fmt_link() {
  # $1: text, $2: url, $3: fallback mode
  if supports_hyperlinks; then
    printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$2" "$1"
    return
  fi

  case "$3" in
  --text) printf '%s\n' "$1" ;;
  --url|*) fmt_underline "$2" ;;
  esac
}

fmt_underline() {
  is_tty && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

setopt typeset_silent
typeset -a RAINBOW

if is_tty; then
  if supports_truecolor; then
    RAINBOW=(
      "$(printf '\033[38;2;255;0;0m')"
      "$(printf '\033[38;2;255;97;0m')"
      "$(printf '\033[38;2;247;255;0m')"
      "$(printf '\033[38;2;0;255;30m')"
      "$(printf '\033[38;2;77;0;255m')"
      "$(printf '\033[38;2;168;0;255m')"
      "$(printf '\033[38;2;245;0;172m')"
    )
  else
    RAINBOW=(
      "$(printf '\033[38;5;196m')"
      "$(printf '\033[38;5;202m')"
      "$(printf '\033[38;5;226m')"
      "$(printf '\033[38;5;082m')"
      "$(printf '\033[38;5;021m')"
      "$(printf '\033[38;5;093m')"
      "$(printf '\033[38;5;163m')"
    )
  fi

  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[0m')
fi

# Update upstream remote to ohmyzsh org
git remote -v | while read remote url extra; do
  case "$url" in
  git://github.com/robbyrussell/oh-my-zsh(|.git))
    # Update out-of-date "unauthenticated git protocol on port 9418" to https
    git remote set-url "$remote" "https://github.com/ohmyzsh/ohmyzsh.git" ;;
  https://github.com/robbyrussell/oh-my-zsh(|.git))
    git remote set-url "$remote" "https://github.com/ohmyzsh/ohmyzsh.git" ;;
  git@github.com:robbyrussell/oh-my-zsh(|.git))
    git remote set-url "$remote" "git@github.com:ohmyzsh/ohmyzsh.git" ;;
  https://github.com/ohmyzsh/ohmyzsh(|.git)) ;;
  git@github.com:ohmyzsh/ohmyzsh(|.git)) ;;
  *) continue ;;
  esac

  # If we reach this point we have found the proper ohmyzsh upstream remote. If we don't,
  # we'll only update from the set remote if `oh-my-zsh.remote` has been set to a remote,
  # as when installing from a fork.
  git config --local oh-my-zsh.remote "$remote"
  break
done

# Set git-config values known to fix git errors
# Line endings (#4069)
git config core.eol lf
git config core.autocrlf false
# zeroPaddedFilemode fsck errors (#4963)
git config fsck.zeroPaddedFilemode ignore
git config fetch.fsck.zeroPaddedFilemode ignore
git config receive.fsck.zeroPaddedFilemode ignore
# autostash on rebase (#7172)
resetAutoStash=$(git config --bool rebase.autoStash 2>/dev/null)
git config rebase.autoStash true

local ret=0

# repository settings
remote=${"$(git config --local oh-my-zsh.remote)":-origin}
branch=${"$(git config --local oh-my-zsh.branch)":-master}

# repository state
last_head=$(git symbolic-ref --quiet --short HEAD || git rev-parse HEAD)
# checkout update branch
git checkout -q "$branch" -- || exit 1
# branch commit before update (used in changelog)
last_commit=$(git rev-parse "$branch")

# Update Oh My Zsh
if [[ $verbose_mode != silent ]]; then
  printf "${BLUE}%s${RESET}\n" "Updating Oh My Zsh"
fi
if LANG= git pull --quiet --rebase $remote $branch; then
  # Check if it was really updated or not
  if [[ "$(git rev-parse HEAD)" = "$last_commit" ]]; then
    message="Oh My Zsh is already at the latest version."
  else
    message="Hooray! Oh My Zsh has been updated!"

    # Save the commit prior to updating
    git config oh-my-zsh.lastVersion "$last_commit"

    # Print changelog to the terminal
    if [[ $interactive == true && $verbose_mode == default ]]; then
      "$ZSH/tools/changelog.sh" HEAD "$last_commit"
    fi

    if [[ $verbose_mode != silent ]]; then
      printf "${BLUE}%s \`${BOLD}%s${RESET}${BLUE}\`${RESET}\n" "You can see the changelog with" "omz changelog"
    fi
  fi

  if [[ $verbose_mode == default ]]; then
    printf '%s         %s__      %s           %s        %s       %s     %s__   %s\n'      $RAINBOW $RESET
    printf '%s  ____  %s/ /_    %s ____ ___  %s__  __  %s ____  %s_____%s/ /_  %s\n'      $RAINBOW $RESET
    printf '%s / __ \\%s/ __ \\  %s / __ `__ \\%s/ / / / %s /_  / %s/ ___/%s __ \\ %s\n'  $RAINBOW $RESET
    printf '%s/ /_/ /%s / / / %s / / / / / /%s /_/ / %s   / /_%s(__  )%s / / / %s\n'      $RAINBOW $RESET
    printf '%s\\____/%s_/ /_/ %s /_/ /_/ /_/%s\\__, / %s   /___/%s____/%s_/ /_/  %s\n'    $RAINBOW $RESET
    printf '%s    %s        %s           %s /____/ %s       %s     %s          %s\n'      $RAINBOW $RESET
    printf '\n'
    printf "${BLUE}%s${RESET}\n\n" "$message"
    printf "${BLUE}${BOLD}%s %s${RESET}\n" "To keep up with the latest news and updates, follow us on Twitter:" "$(fmt_link @ohmyzsh https://twitter.com/ohmyzsh)"
    printf "${BLUE}${BOLD}%s %s${RESET}\n" "Want to get involved in the community? Join our Discord:" "$(fmt_link "Discord server" https://discord.gg/ohmyzsh)"
    printf "${BLUE}${BOLD}%s %s${RESET}\n" "Get your Oh My Zsh swag at:" "$(fmt_link "Planet Argon Shop" https://shop.planetargon.com/collections/oh-my-zsh)"
  elif [[ $verbose_mode == minimal ]]; then
    printf "${BLUE}%s${RESET}\n" "$message"
  fi
else
  ret=$?
  printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
fi

# go back to HEAD previous to update
git checkout -q "$last_head" --

# Unset git-config values set just for the upgrade
case "$resetAutoStash" in
  "") git config --unset rebase.autoStash ;;
  *) git config rebase.autoStash "$resetAutoStash" ;;
esac

# Exit with `1` if the update failed
exit $ret
