# Find where asdf should be installed.
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"

# Load asdf, if found.
if [ -f $ASDF_DIR/asdf.sh ]; then
    . $ASDF_DIR/asdf.sh
fi
