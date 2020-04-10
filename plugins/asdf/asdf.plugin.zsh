# Find where asdf should be installed
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"

# If not found, check for Homebrew package
if [[ ! -f "$ASDF_DIR/asdf.sh" ]] && (( $+commands[brew] )); then
   ASDF_DIR="$(brew --prefix asdf)"
fi

# Load command
if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
    . "$ASDF_DIR/asdf.sh"
fi
