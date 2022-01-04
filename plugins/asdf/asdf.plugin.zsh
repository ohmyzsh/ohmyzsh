# Find where asdf should be installed
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
ASDF_COMPLETIONS="$ASDF_DIR/completions"

# If not found, check for archlinux/AUR package (/opt/asdf-vm/)
if [[ ! -f "$ASDF_DIR/asdf.sh" || ! -f "$ASDF_COMPLETIONS/asdf.bash" ]] && [[ -f "/opt/asdf-vm/asdf.sh" ]]; then
  ASDF_DIR="/opt/asdf-vm"
  ASDF_COMPLETIONS="$ASDF_DIR"
fi

# If not found, check for Homebrew package
if [[ ! -f "$ASDF_DIR/asdf.sh" || ! -f "$ASDF_COMPLETIONS/asdf.bash" ]] && (( $+commands[brew] )); then
  brew_prefix="$(brew --prefix asdf)"
  ASDF_DIR="${brew_prefix}/libexec"
  ASDF_COMPLETIONS="${brew_prefix}/etc/bash_completion.d"
  unset brew_prefix
fi

# Load command
if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
  . "$ASDF_DIR/asdf.sh"

  # Load completions
  if [[ -f "$ASDF_COMPLETIONS/asdf.bash" ]]; then
    . "$ASDF_COMPLETIONS/asdf.bash"
  fi
fi
