function zle-copy-to-clipboard {
    local selected_text start_pos end_pos

    (( $MARK < $CURSOR ))
        && { start_pos=$MARK; end_pos=$CURSOR; }
        || { start_pos=$CURSOR; end_pos=$MARK; }

    (( start_pos < 0 || end_pos < 0 ))
        && zle -R && return

    selected_text="${BUFFER[$start_pos+1, $end_pos]}"

    command -v xclip &> /dev/null
        && ( echo -n "$selected_text" | xclip -selection clipboard )
        && zle -R && return

    command -v wl-copy &> /dev/null
        && ( echo -n "$selected_text" | wl-copy )
        && zle -R && return

    zle -R
}

function zle-paste-from-clipboard {
    local clipboard_content

    command -v xclip &> /dev/null
        && clipboard_content=$(xclip -selection clipboard -o 2>/dev/null)
    command -v wl-paste &> /dev/null
        && clipboard_content=$(wl-paste --no-newline 2>/dev/null)

    [[ -z "$clipboard_content" ]] && return

    LBUFFER+="$clipboard_content"
    zle -R
}

zle -N zle-copy-to-clipboard
zle -N zle-paste-from-clipboard

# these 2 CSI from ghostty are sent for Ctrl+Shift+C and Ctrl+Shift+V
bindkey '^[[99;6u' zle-copy-to-clipboard
bindkey '^[[118;6u' zle-paste-from-clipboard
