# Find where asdf should be installed.
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"

# Load asdf, if found.
if [ -f $ASDF_DIR/asdf.sh ]; then
    . $ASDF_DIR/asdf.sh
fi

# Load asdf completions, if found.
if [ -f $ASDF_DIR/completions/asdf.bash ]; then
    . $ASDF_DIR/completions/asdf.bash
fi
