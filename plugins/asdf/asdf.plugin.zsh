# Find where asdf should be installed
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
ASDF_COMPLETIONS="$ASDF_DIR/completions"

# If not found, check for Homebrew package
if [[ ! -f "$ASDF_DIR/asdf.sh" || ! -f "$ASDF_COMPLETIONS/asdf.bash" ]] && (( $+commands[brew] )); then
   ASDF_DIR="$(brew --prefix asdf)"
   ASDF_COMPLETIONS="$ASDF_DIR/etc/bash_completion.d"
fi

# Load command
if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
    . "$ASDF_DIR/asdf.sh"

    # Load completions
    if [[ -f "$ASDF_COMPLETIONS/asdf.bash" ]]; then
        . "$ASDF_COMPLETIONS/asdf.bash"
    fi
fi
