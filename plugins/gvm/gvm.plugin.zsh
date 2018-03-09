# Set GVM_ROOT if it isn't already defined
[[ -z "$GVM_ROOT" ]] && export GVM_ROOT="$HOME/.gvm"

# Load gvm if it exists
[[ -f "$GVM_ROOT/scripts/gvm" ]] && source "$GVM_ROOT/scripts/gvm"
