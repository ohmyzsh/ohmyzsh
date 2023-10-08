# Find where rtx should be installed
RTX_DIR="${RTX_DIR:-$HOME/.rtx}"
RTX_COMPLETIONS="$RTX_DIR/completions"

if [[ ! -f "$RTX_DIR/rtx.sh" || ! -f "$RTX_COMPLETIONS/_rtx" ]]; then
  # If not found, check for archlinux/AUR package (/opt/rtx-vm/)
  if [[ -f "/opt/rtx-vm/rtx.sh" ]]; then
    RTX_DIR="/opt/rtx-vm"
    RTX_COMPLETIONS="$RTX_DIR"
  # If not found, check for Homebrew package
  elif (( $+commands[brew] )); then
    _RTX_PREFIX="$(brew --prefix rtx)"
    RTX_DIR="${_RTX_PREFIX}/libexec"
    RTX_COMPLETIONS="${_RTX_PREFIX}/share/zsh/site-functions"
    unset _RTX_PREFIX
  else
    return
  fi
fi

# Load command
if [[ -f "$RTX_DIR/rtx.sh" ]]; then
  source "$RTX_DIR/rtx.sh"
  # Load completions
  if [[ -f "$RTX_COMPLETIONS/_rtx" ]]; then
    fpath+=("$RTX_COMPLETIONS")
    autoload -Uz _rtx
    compdef _rtx rtx # compdef is already loaded before loading plugins
  fi
fi
