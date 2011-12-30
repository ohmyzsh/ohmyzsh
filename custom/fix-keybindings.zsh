
# bash like history search
# PGUP, PGDN, HOME, END
bindtc ()
{
        setopt localoptions
        local keyval=$(echotc "$1" 2>&-)
        [[ $keyval == "no" ]] && keyval=""
        bindkey "${keyval:-$2}" "$3"
}

# Bindings for PGUP, PGDN, HOME, END
bindtc kP "^[[I" history-beginning-search-backward
bindtc kN "^[[G" history-beginning-search-forward
bindtc kh "^[[7~" beginning-of-line
bindtc kH "^[[8~" end-of-line

# Bindings for UP, DOWN, LEFT, RIGHT
bindtc ku "^[[A" up-line-or-history
bindtc kd "^[[B" down-line-or-history
bindtc kr "^[[C" forward-char
bindtc kl "^[[D" backward-char

# make del behave
bindkey "^[[3~" delete-char

