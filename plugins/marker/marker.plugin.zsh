if [[ -s "$HOME/.local/share/marker/marker.sh" ]]; then
    export MARKER_KEY_MARK='\C-k'
    export MARKER_KEY_GET='\C-@'
    export MARKER_KEY_NEXT_PLACEHOLDER='\C-t'
   source "$HOME/.local/share/marker/marker.sh"
fi

