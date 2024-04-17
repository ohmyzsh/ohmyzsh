#!/bin/sh
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# or via fetch:
#   sh -c "$(fetch -o - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#
# As an alternative, you can first download the install script and run it afterwards:
#   wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#   sh install.sh
#
# You can tweak the install behavior by setting variables when running the script. For
# example, to change the path to the Oh My Zsh repository:
#   ZSH=~/.zsh sh install.sh
#
# Respects the following environment variables:
#   ZDOTDIR - path to Zsh dotfiles directory (default: unset). See [1][2]
#             [1] https://zsh.sourceforge.io/Doc/Release/Parameters.html#index-ZDOTDIR
#             [2] https://zsh.sourceforge.io/Doc/Release/Files.html#index-ZDOTDIR_002c-use-of
#   ZSH     - path to the Oh My Zsh repository folder (default: $HOME/.oh-my-zsh)
#   REPO    - name of the GitHub repo to install from (default: ohmyzsh/ohmyzsh)
#   REMOTE  - full remote URL of the git repo to install (default: GitHub via HTTPS)
#   BRANCH  - branch to check out immediately after install (default: master)
#
# Other options:
#   CHSH       - 'no' means the installer will not change the default shell (default: yes)
#   RUNZSH     - 'no' means the installer will not run zsh after the install (default: yes)
#   KEEP_ZSHRC - 'yes' means the installer will not replace an existing .zshrc (default: no)
#
# You can also pass some arguments to the install script to set some these options:
#   --skip-chsh: has the same behavior as setting CHSH to 'no'
#   --unattended: sets both CHSH and RUNZSH to 'no'
#   --keep-zshrc: sets KEEP_ZSHRC to 'yes'
# For example:
#   sh install.sh --unattended
# or:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
#
set -e

# Make sure important variables exist if not already defined
#
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"


# Track if $ZSH was provided
custom_zsh=${ZSH:+yes}

# Use $zdot to keep track of where the directory is for zsh dotfiles
# To check if $ZDOTDIR was provided, explicitly check for $ZDOTDIR
zdot="${ZDOTDIR:-$HOME}"

# Default value for $ZSH
# a) if $ZDOTDIR is supplied and not $HOME: $ZDOTDIR/ohmyzsh
# b) otherwise, $HOME/.oh-my-zsh
if [ -n "$ZDOTDIR" ] && [ "$ZDOTDIR" != "$HOME" ]; then
  ZSH="${ZSH:-$ZDOTDIR/ohmyzsh}"
fi
ZSH="${ZSH:-$HOME/.oh-my-zsh}"

# Default settings
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

# Other options
CHSH=${CHSH:-yes}
RUNZSH=${RUNZSH:-yes}
KEEP_ZSHRC=${KEEP_ZSHRC:-no}


command_exists() {
  command -v "$@" >/dev/null 2>&1
}

user_can_sudo() {
  # Check if sudo is installed
  command_exists sudo || return 1
  # Termux can't run sudo, so we can detect it and exit the function early.
  case "$PREFIX" in
  *com.termux*) return 1 ;;
  esac
  # The following command has 3 parts:
  #
  # 1. Run `sudo` with `-v`. Does the following:
  #    • with privilege: asks for a password immediately.
  #    • without privilege: exits with error code 1 and prints the message:
  #      Sorry, user <username> may not run sudo on <hostname>
  #
  # 2. Pass `-n` to `sudo` to tell it to not ask for a password. If the
  #    password is not required, the command will finish with exit code 0.
  #    If one is required, sudo will exit with error code 1 and print the
  #    message:
  #    sudo: a password is required
  #
  # 3. Check for the words "may not run sudo" in the output to really tell
  #    whether the user has privileges or not. For that we have to make sure
  #    to run `sudo` in the default locale (with `LANG=`) so that the message
  #    stays consistent regardless of the user's locale.
  #
  ! LANG= sudo -n -v 2>&1 | grep -q "may not run sudo"
}

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
  Hyper|iTerm.app|terminology|WezTerm|vscode) return 0 ;;
  esac

  # These termcap entries support hyperlinks
  case "$TERM" in
  xterm-kitty|alacritty|alacritty-direct) return 0 ;;
  esac

  # xfce4-terminal supports hyperlinks
  if [ "$COLORTERM" = "xfce4-terminal" ]; then
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

# shellcheck disable=SC2016 # backtick in single-quote
fmt_code() {
  is_tty && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

fmt_error() {
  printf '%sError: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "$FMT_RESET" >&2
}

setup_color() {
  # Only use colors if connected to a terminal
  if ! is_tty; then
    FMT_RAINBOW=""
    FMT_RED=""
    FMT_GREEN=""
    FMT_YELLOW=""
    FMT_BLUE=""
    FMT_BOLD=""
    FMT_RESET=""
    return
  fi

  if supports_truecolor; then
    FMT_RAINBOW="
      $(printf '\033[38;2;255;0;0m')
      $(printf '\033[38;2;255;97;0m')
      $(printf '\033[38;2;247;255;0m')
      $(printf '\033[38;2;0;255;30m')
      $(printf '\033[38;2;77;0;255m')
      $(printf '\033[38;2;168;0;255m')
      $(printf '\033[38;2;245;0;172m')
    "
  else
    FMT_RAINBOW="
      $(printf '\033[38;5;196m')
      $(printf '\033[38;5;202m')
      $(printf '\033[38;5;226m')
      $(printf '\033[38;5;082m')
      $(printf '\033[38;5;021m')
      $(printf '\033[38;5;093m')
      $(printf '\033[38;5;163m')
    "
  fi

  FMT_RED=$(printf '\033[31m')
  FMT_GREEN=$(printf '\033[32m')
  FMT_YELLOW=$(printf '\033[33m')
  FMT_BLUE=$(printf '\033[34m')
  FMT_BOLD=$(printf '\033[1m')
  FMT_RESET=$(printf '\033[0m')
}

setup_ohmyzsh() {
  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  echo "${FMT_BLUE}Cloning Oh My Zsh...${FMT_RESET}"

  command_exists git || {
    fmt_error "git is not installed"
    exit 1
  }

  ostype=$(uname)
  if [ -z "${ostype%CYGWIN*}" ] && git --version | grep -Eq 'msysgit|windows'; then
    fmt_error "Windows/MSYS Git is not supported on Cygwin"
    fmt_error "Make sure the Cygwin git package is installed and is first on the \$PATH"
    exit 1
  fi

  # Manual clone with git config options to support git < v1.7.2
  git init --quiet "$ZSH" && cd "$ZSH" \
  && git config core.eol lf \
  && git config core.autocrlf false \
  && git config fsck.zeroPaddedFilemode ignore \
  && git config fetch.fsck.zeroPaddedFilemode ignore \
  && git config receive.fsck.zeroPaddedFilemode ignore \
  && git config oh-my-zsh.remote origin \
  && git config oh-my-zsh.branch "$BRANCH" \
  && git remote add origin "$REMOTE" \
  && git fetch --depth=1 origin \
  && git checkout -b "$BRANCH" "origin/$BRANCH" || {
    [ ! -d "$ZSH" ] || {
      cd -
      rm -rf "$ZSH" 2>/dev/null
    }
    fmt_error "git clone of oh-my-zsh repo failed"
    exit 1
  }
  # Exit installation directory
  cd -

  echo
}

setup_zshrc() {
  # Keep most recent old .zshrc at .zshrc.pre-oh-my-zsh, and older ones
  # with datestamp of installation that moved them aside, so we never actually
  # destroy a user's original zshrc
  echo "${FMT_BLUE}Looking for an existing zsh config...${FMT_RESET}"

  # Must use this exact name so uninstall.sh can find it
  OLD_ZSHRC="$zdot/.zshrc.pre-oh-my-zsh"
  if [ -f "$zdot/.zshrc" ] || [ -h "$zdot/.zshrc" ]; then
    # Skip this if the user doesn't want to replace an existing .zshrc
    if [ "$KEEP_ZSHRC" = yes ]; then
      echo "${FMT_YELLOW}Found ${zdot}/.zshrc.${FMT_RESET} ${FMT_GREEN}Keeping...${FMT_RESET}"
      return
    fi
    if [ -e "$OLD_ZSHRC" ]; then
      OLD_OLD_ZSHRC="${OLD_ZSHRC}-$(date +%Y-%m-%d_%H-%M-%S)"
      if [ -e "$OLD_OLD_ZSHRC" ]; then
        fmt_error "$OLD_OLD_ZSHRC exists. Can't back up ${OLD_ZSHRC}"
        fmt_error "re-run the installer again in a couple of seconds"
        exit 1
      fi
      mv "$OLD_ZSHRC" "${OLD_OLD_ZSHRC}"

      echo "${FMT_YELLOW}Found old .zshrc.pre-oh-my-zsh." \
        "${FMT_GREEN}Backing up to ${OLD_OLD_ZSHRC}${FMT_RESET}"
    fi
    echo "${FMT_YELLOW}Found ${zdot}/.zshrc.${FMT_RESET} ${FMT_GREEN}Backing up to ${OLD_ZSHRC}${FMT_RESET}"
    mv "$zdot/.zshrc" "$OLD_ZSHRC"
  fi

  echo "${FMT_GREEN}Using the Oh My Zsh template file and adding it to $zdot/.zshrc.${FMT_RESET}"

  # Modify $ZSH variable in .zshrc directory to use the literal $ZDOTDIR or $HOME
  omz="$ZSH"
  if [ -n "$ZDOTDIR" ] && [ "$ZDOTDIR" != "$HOME" ]; then
    omz=$(echo "$omz" | sed "s|^$ZDOTDIR/|\$ZDOTDIR/|")
  fi
  omz=$(echo "$omz" | sed "s|^$HOME/|\$HOME/|")

  sed "s|^export ZSH=.*$|export ZSH=\"${omz}\"|" "$ZSH/templates/zshrc.zsh-template" > "$zdot/.zshrc-omztemp"
  mv -f "$zdot/.zshrc-omztemp" "$zdot/.zshrc"

  echo
}

setup_shell() {
  # Skip setup if the user wants or stdin is closed (not running interactively).
  if [ "$CHSH" = no ]; then
    return
  fi

  # If this user's login shell is already "zsh", do not attempt to switch.
  if [ "$(basename -- "$SHELL")" = "zsh" ]; then
    return
  fi

  # If this platform doesn't provide a "chsh" command, bail out.
  if ! command_exists chsh; then
    cat <<EOF
I can't change your shell automatically because this system does not have chsh.
${FMT_BLUE}Please manually change your default shell to zsh${FMT_RESET}
EOF
    return
  fi

  echo "${FMT_BLUE}Time to change your default shell to zsh:${FMT_RESET}"

  # Prompt for user choice on changing the default login shell
  printf '%sDo you want to change your default shell to zsh? [Y/n]%s ' \
    "$FMT_YELLOW" "$FMT_RESET"
  read -r opt
  case $opt in
    y*|Y*|"") ;;
    n*|N*) echo "Shell change skipped."; return ;;
    *) echo "Invalid choice. Shell change skipped."; return ;;
  esac

  # Check if we're running on Termux
  case "$PREFIX" in
    *com.termux*) termux=true; zsh=zsh ;;
    *) termux=false ;;
  esac

  if [ "$termux" != true ]; then
    # Test for the right location of the "shells" file
    if [ -f /etc/shells ]; then
      shells_file=/etc/shells
    elif [ -f /usr/share/defaults/etc/shells ]; then # Solus OS
      shells_file=/usr/share/defaults/etc/shells
    else
      fmt_error "could not find /etc/shells file. Change your default shell manually."
      return
    fi

    # Get the path to the right zsh binary
    # 1. Use the most preceding one based on $PATH, then check that it's in the shells file
    # 2. If that fails, get a zsh path from the shells file, then check it actually exists
    if ! zsh=$(command -v zsh) || ! grep -qx "$zsh" "$shells_file"; then
      if ! zsh=$(grep '^/.*/zsh$' "$shells_file" | tail -n 1) || [ ! -f "$zsh" ]; then
        fmt_error "no zsh binary found or not present in '$shells_file'"
        fmt_error "change your default shell manually."
        return
      fi
    fi
  fi

  # We're going to change the default shell, so back up the current one
  if [ -n "$SHELL" ]; then
    echo "$SHELL" > "$zdot/.shell.pre-oh-my-zsh"
  else
    grep "^$USER:" /etc/passwd | awk -F: '{print $7}' > "$zdot/.shell.pre-oh-my-zsh"
  fi

  echo "Changing your shell to $zsh..."

  # Check if user has sudo privileges to run `chsh` with or without `sudo`
  #
  # This allows the call to succeed without password on systems where the
  # user does not have a password but does have sudo privileges, like in
  # Google Cloud Shell.
  #
  # On systems that don't have a user with passwordless sudo, the user will
  # be prompted for the password either way, so this shouldn't cause any issues.
  #
  if user_can_sudo; then
    sudo -k chsh -s "$zsh" "$USER"  # -k forces the password prompt
  else
    chsh -s "$zsh" "$USER"          # run chsh normally
  fi

  # Check if the shell change was successful
  if [ $? -ne 0 ]; then
    fmt_error "chsh command unsuccessful. Change your default shell manually."
  else
    export SHELL="$zsh"
    echo "${FMT_GREEN}Shell successfully changed to '$zsh'.${FMT_RESET}"
  fi

  echo
}

# shellcheck disable=SC2183  # printf string has more %s than arguments ($FMT_RAINBOW expands to multiple arguments)
print_success() {
  printf '%s         %s__      %s           %s        %s       %s     %s__   %s\n'      $FMT_RAINBOW $FMT_RESET
  printf '%s  ____  %s/ /_    %s ____ ___  %s__  __  %s ____  %s_____%s/ /_  %s\n'      $FMT_RAINBOW $FMT_RESET
  printf '%s / __ \\%s/ __ \\  %s / __ `__ \\%s/ / / / %s /_  / %s/ ___/%s __ \\ %s\n'  $FMT_RAINBOW $FMT_RESET
  printf '%s/ /_/ /%s / / / %s / / / / / /%s /_/ / %s   / /_%s(__  )%s / / / %s\n'      $FMT_RAINBOW $FMT_RESET
  printf '%s\\____/%s_/ /_/ %s /_/ /_/ /_/%s\\__, / %s   /___/%s____/%s_/ /_/  %s\n'    $FMT_RAINBOW $FMT_RESET
  printf '%s    %s        %s           %s /____/ %s       %s     %s          %s....is now installed!%s\n' $FMT_RAINBOW $FMT_GREEN $FMT_RESET
  printf '\n'
  printf '\n'
  printf "%s %s %s\n" "Before you scream ${FMT_BOLD}${FMT_YELLOW}Oh My Zsh!${FMT_RESET} look over the" \
    "$(fmt_code "$(fmt_link ".zshrc" "file://$zdot/.zshrc" --text)")" \
    "file to select plugins, themes, and options."
  printf '\n'
  printf '%s\n' "• Follow us on Twitter: $(fmt_link @ohmyzsh https://twitter.com/ohmyzsh)"
  printf '%s\n' "• Join our Discord community: $(fmt_link "Discord server" https://discord.gg/ohmyzsh)"
  printf '%s\n' "• Get stickers, t-shirts, coffee mugs and more: $(fmt_link "Planet Argon Shop" https://shop.planetargon.com/collections/oh-my-zsh)"
  printf '%s\n' $FMT_RESET
}

main() {
  # Run as unattended if stdin is not a tty
  if [ ! -t 0 ]; then
    RUNZSH=no
    CHSH=no
  fi

  # Parse arguments
  while [ $# -gt 0 ]; do
    case $1 in
      --unattended) RUNZSH=no; CHSH=no ;;
      --skip-chsh) CHSH=no ;;
      --keep-zshrc) KEEP_ZSHRC=yes ;;
    esac
    shift
  done

  setup_color

  if ! command_exists zsh; then
    echo "${FMT_YELLOW}Zsh is not installed.${FMT_RESET} Please install zsh first."
    exit 1
  fi

  if [ -d "$ZSH" ]; then
    echo "${FMT_YELLOW}The \$ZSH folder already exists ($ZSH).${FMT_RESET}"
    if [ "$custom_zsh" = yes ]; then
      cat <<EOF

You ran the installer with the \$ZSH setting or the \$ZSH variable is
exported. You have 3 options:

1. Unset the ZSH variable when calling the installer:
   $(fmt_code "ZSH= sh install.sh")
2. Install Oh My Zsh to a directory that doesn't exist yet:
   $(fmt_code "ZSH=path/to/new/ohmyzsh/folder sh install.sh")
3. (Caution) If the folder doesn't contain important information,
   you can just remove it with $(fmt_code "rm -r $ZSH")

EOF
    else
      echo "You'll need to remove it if you want to reinstall."
    fi
    exit 1
  fi

  # Create ZDOTDIR folder structure if it doesn't exist
  if [ -n "$ZDOTDIR" ]; then
    mkdir -p "$ZDOTDIR"
  fi

  setup_ohmyzsh
  setup_zshrc
  setup_shell

  print_success

  if [ $RUNZSH = no ]; then
    echo "${FMT_YELLOW}Run zsh to try it out.${FMT_RESET}"
    exit
  fi

  exec zsh -l
}

main "$@"
