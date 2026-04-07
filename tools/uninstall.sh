#!/bin/sh

# Make sure important variables exist if not already defined
#
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd "$USER" 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent; use dscl to query the directory service
HOME="${HOME:-$(dscl . -read "/Users/$USER" NFSHomeDirectory 2>/dev/null | awk '{print $2}')}"
# Last resort: tilde expansion via eval (POSIX, but carries injection risk)
HOME="${HOME:-$(eval "echo ~$USER" 2>/dev/null)}"

if [ -z "$HOME" ]; then
  echo >&2 "Error: could not determine HOME directory"
  exit 1
fi

zdot="${ZDOTDIR:-$HOME}"

# Default OMZ directory (matches tools/install.sh logic)
if [ -n "$ZDOTDIR" ] && [ "$ZDOTDIR" != "$HOME" ]; then
  OMZ_DIR="${ZSH:-$ZDOTDIR/ohmyzsh}"
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
  rm -rf "$OMZ_DIR"
fi

if [ -e "$zdot/.zshrc" ]; then
  ZSHRC_SAVE="$zdot/.zshrc.omz-uninstalled-$(date +%Y-%m-%d_%H-%M-%S)"
  echo "Found $zdot/.zshrc -- Renaming to ${ZSHRC_SAVE}"
  mv "$zdot/.zshrc" "${ZSHRC_SAVE}"
fi

echo "Looking for original zsh config..."
ZSHRC_ORIG="$zdot/.zshrc.pre-oh-my-zsh"
if [ -e "$ZSHRC_ORIG" ]; then
  echo "Found $ZSHRC_ORIG -- Restoring to $zdot/.zshrc"
  mv "$ZSHRC_ORIG" "$zdot/.zshrc"
  echo "Your original zsh config was restored."
else
  echo "No original zsh config found"
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
echo "Don't forget to restart your terminal!"
