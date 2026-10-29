#!/bin/sh

# Make sure important variables exist if not already defined
#
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
current_uid=$(id -u 2>/dev/null)
current_user=$(id -u -n 2>/dev/null)
HOME=${HOME:-}
if [ -z "$HOME" ] && [ -n "$current_uid" ] && command -v getent >/dev/null 2>&1; then
  HOME=$(getent passwd "$current_uid" 2>/dev/null | cut -d: -f6)
fi
# macOS does not have getent; use dscl to query the directory service.
if [ -z "$HOME" ] && [ -n "$current_user" ] && command -v dscl >/dev/null 2>&1; then
  HOME=$(dscl . -read "/Users/$current_user" NFSHomeDirectory 2>/dev/null | awk '{print $2}')
fi
if [ -z "$HOME" ] && [ -n "$current_uid" ] && [ -r /etc/passwd ]; then
  HOME=$(awk -F: -v uid="$current_uid" '$3 == uid { print $6; exit }' /etc/passwd)
fi

HOME=${HOME%"${HOME##*[!/]}"}
case "$HOME" in
  ""|/) echo >&2 "Error: could not determine HOME directory"; exit 1 ;;
  /*) ;;
  *) echo >&2 "Error: could not determine HOME directory"; exit 1 ;;
esac

zdot="${ZDOTDIR:-$HOME}"
zdot=${zdot%"${zdot##*[!/]}"}
case "${zdot:-/}" in
  /|.|..) echo >&2 "Error: refusing unsafe ZDOTDIR '$zdot'"; exit 1 ;;
esac

# Default OMZ directory (matches tools/install.sh logic)
if [ -n "$ZDOTDIR" ] && [ "$zdot" != "$HOME" ]; then
  OMZ_DIR="${ZSH:-$zdot/ohmyzsh}"
else
  OMZ_DIR="${ZSH:-$HOME/.oh-my-zsh}"
fi

# Safety: normalize and refuse to remove dangerous or non-OMZ paths
# Strip all trailing slashes (e.g., "/home/user/" → "/home/user")
OMZ_DIR=${OMZ_DIR%"${OMZ_DIR##*[!/]}"}
case "${OMZ_DIR:-/}" in
  /|.|..|"$HOME"|"$zdot") echo >&2 "Error: refusing to remove '$OMZ_DIR' (unsafe path)"; exit 1 ;;
esac

if [ -d "$OMZ_DIR" ] && [ ! -f "$OMZ_DIR/oh-my-zsh.sh" ]; then
  echo >&2 "Error: '$OMZ_DIR' does not appear to be an Oh My Zsh installation"
  exit 1
fi

if hash chsh >/dev/null 2>&1 && [ -f "$zdot/.shell.pre-oh-my-zsh" ]; then
  old_shell=$(cat "$zdot/.shell.pre-oh-my-zsh")
  echo "Switching your shell back to '$old_shell':"
  if chsh -s "$old_shell"; then
    rm -f "$zdot/.shell.pre-oh-my-zsh"
  else
    echo "Could not change default shell. Change it manually by running chsh"
    echo "or editing the /etc/passwd file."
    exit 1
  fi
fi

printf "Are you sure you want to remove Oh My Zsh? [y/N] "
read -r confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  echo "Uninstall cancelled"
  exit
fi

echo "Removing $OMZ_DIR"
if [ -d "$OMZ_DIR" ]; then
  rm -rf -- "$OMZ_DIR"
fi

if [ -e "$zdot/.zshrc" ]; then
  ZSHRC_SAVE="$zdot/.zshrc.omz-uninstalled-$(date +%Y-%m-%d_%H-%M-%S)"
  echo "Found $zdot/.zshrc -- Renaming to ${ZSHRC_SAVE}"
  mv -- "$zdot/.zshrc" "${ZSHRC_SAVE}"
fi

echo "Looking for original zsh config..."
ZSHRC_ORIG="$zdot/.zshrc.pre-oh-my-zsh"
if [ -e "$ZSHRC_ORIG" ]; then
  echo "Found $ZSHRC_ORIG -- Restoring to $zdot/.zshrc"
  mv -- "$ZSHRC_ORIG" "$zdot/.zshrc"
  echo "Your original zsh config was restored."
else
  echo "No original zsh config found"
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
echo "Don't forget to restart your terminal!"
