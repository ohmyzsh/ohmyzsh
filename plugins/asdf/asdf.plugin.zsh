# Find where asdf should be installed
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
ASDF_COMPLETIONS="$ASDF_DIR/completions"

if [[ ! -f "$ASDF_DIR/asdf.sh" || ! -f "$ASDF_COMPLETIONS/_asdf" ]]; then
  # If not found, check for archlinux/AUR package (/opt/asdf-vm/)
  if [[ -f "/opt/asdf-vm/asdf.sh" ]]; then
    ASDF_DIR="/opt/asdf-vm"
    ASDF_COMPLETIONS="$ASDF_DIR"
  # If not found, check for Homebrew package
  elif (( $+commands[brew] )); then
    _ASDF_PREFIX="$(brew --prefix asdf)"
    ASDF_DIR="${_ASDF_PREFIX}/libexec"
    ASDF_COMPLETIONS="${_ASDF_PREFIX}/share/zsh/site-functions"
    unset _ASDF_PREFIX
  else
    return
  fi
fi

# Load command
if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
  source "$ASDF_DIR/asdf.sh"
  # Load completions
  if [[ -f "$ASDF_COMPLETIONS/_asdf" ]]; then
    fpath+=("$ASDF_COMPLETIONS")
    autoload -Uz _asdf
    compdef _asdf asdf # compdef is already loaded before loading plugins
  fi
fi
