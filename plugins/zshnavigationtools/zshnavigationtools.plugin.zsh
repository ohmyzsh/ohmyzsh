# The preamble comments apply when using ZNT as autoload functions
# https://github.com/psprint/zsh-navigation-tools
# License is GPLv3
# d24c34e1fac51a25d8fa6ca9622d982dc584b6d9 refs/heads/master

n-aliases() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-aliases` to .zshrc
#
# This function allows to choose an alias for edition with vared
#
# Uses n-list

emulate -L zsh

setopt localoptions extendedglob
zmodload zsh/curses

local IFS="
"

[ -f ~/.config/znt/n-list.conf ] && . ~/.config/znt/n-list.conf

local list
local selected

NLIST_REMEMBER_STATE=0

list=( "${(@k)aliases}" )
list=( "${(@M)list:#(#i)*$1*}" )

local NLIST_GREP_STRING="$1"

if [ "$#list" -eq 0 ]; then
    echo "No matching aliases"
    return 1
fi

list=( "${(@i)list}" )
n-list "$list[@]"

if [ "$REPLY" -gt 0 ]; then
    selected="$reply[$REPLY]"
    echo "Editing \`$selected':"
    print -rs "vared aliases\\[$selected\\]"
    vared aliases\[$selected\]
fi

# vim: set filetype=zsh:
}
alias naliases=n-aliases

n-cd() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-cd` to .zshrc
#
# This function allows to choose a directory from pushd stack
#
# Uses n-list

emulate -L zsh

setopt localoptions extendedglob pushdignoredups

zmodload zsh/curses
local IFS="
"

[ -f ~/.config/znt/n-list.conf ] && . ~/.config/znt/n-list.conf

local list
local selected

NLIST_REMEMBER_STATE=0

list=( `dirs -p` )
list=( "${(@M)list:#(#i)*$1*}" )

local NLIST_GREP_STRING="$1"

[ "$#list" -eq 0 ] && echo "No matching directories"

[ -f ~/.config/znt/n-cd.conf ] && . ~/.config/znt/n-cd.conf
if [ "$#hotlist" -gt 1 ]; then
    typeset -a NLIST_NONSELECTABLE_ELEMENTS NLIST_HOP_INDEXES
    integer tmp_list_size="$#list"
    NLIST_NONSELECTABLE_ELEMENTS=( $(( tmp_list_size+1 )) $(( tmp_list_size+2 )) )
    list=( "$list[@]" "" $'\x1b[00;31m'"Hotlist:"$'\x1b[00;00m' "$hotlist[@]" )
    NLIST_HOP_INDEXES=( 1 $(( tmp_list_size+3 )) $#list )
else
    [ "$#list" -eq 0 ] && return 1
fi

n-list "${list[@]}"

if [ "$REPLY" -gt 0 ]; then
    selected="$reply[$REPLY]"
    selected="${selected/#\~/$HOME}"
    echo "You have selected $selected"
    (( NCD_DONT_PUSHD )) && setopt NO_AUTO_PUSHD
    cd "$selected"
    (( NCD_DONT_PUSHD )) && setopt AUTO_PUSHD
fi

# vim: set filetype=zsh:
}
alias ncd=n-cd

n-env() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-env` to .zshrc
#
# This function allows to choose an environment variable
# for edition with vared
#
# Uses n-list

emulate -L zsh

setopt localoptions extendedglob
unsetopt equals
zmodload zsh/curses

local IFS="
"

[ -f ~/.config/znt/n-list.conf ] && . ~/.config/znt/n-list.conf

local list
local selected

NLIST_REMEMBER_STATE=0

list=( `env` )
list=( "${(@M)list:#(#i)*$1*}" )

local NLIST_GREP_STRING="$1"

if [ "$#list" -eq 0 ]; then
    echo "No matching variables"
    return 1
fi

list=( "${(@i)list}" )
n-list "$list[@]"

if [ "$REPLY" -gt 0 ]; then
    selected="$reply[$REPLY]"
    selected="${selected%%=*}"
    echo "Editing \`$selected':"
    print -rs "vared \"$selected\""
    vared "$selected"
fi

# vim: set filetype=zsh:
}
alias nenv=n-env

n-functions() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-functions` to .zshrc
#
# This function allows to choose a function for edition with vared
#
# Uses n-list

emulate -L zsh

setopt localoptions extendedglob
zmodload zsh/curses

local IFS="
"

[ -f ~/.config/znt/n-list.conf ] && . ~/.config/znt/n-list.conf

local list
local selected

NLIST_REMEMBER_STATE=0

# Read configuration
[ -f ~/.config/znt/n-functions.conf ] && . ~/.config/znt/n-functions.conf

list=( "${(@k)functions}" )
list=( "${(@M)list:#(#i)*$1*}" )

local NLIST_GREP_STRING="$1"

if [ "$#list" -eq 0 ]; then
    echo "No matching functions"
    return 1
fi

list=( "${(@i)list}" )
n-list "$list[@]"

if [ "$REPLY" -gt 0 ]; then
    selected="$reply[$REPLY]"
    if [ "$feditor" = "zed" ]; then
        echo "Editing \`$selected' (ESC ZZ or Ctrl-x-w to finish):"
        autoload zed
        print -rs "zed -f \"$selected\""
        zed -f "$selected"
    else
        echo "Editing \`$selected':"
        print -rs "vared functions\\[$selected\\]"
        vared functions\[$selected\]
    fi
fi

# vim: set filetype=zsh:
}
alias nfunctions=n-functions

n-history() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-history` to .zshrc
#
# This function allows to browse Z shell's history and use the
# entries
#
# Uses n-list

emulate -L zsh

setopt localoptions extendedglob
zmodload zsh/curses

local IFS="
"

[ -f ~/.config/znt/n-list.conf ] && . ~/.config/znt/n-list.conf

local list
local selected

NLIST_REMEMBER_STATE=0

list=( `builtin history -rn 1` )
list=( "${(@M)list:#(#i)*$1*}" )

local NLIST_GREP_STRING="$1"

if [ "$#list" -eq 0 ]; then
    echo "No matching history entries"
    return 1
fi

n-list "${list[@]}"

if [ "$REPLY" -gt 0 ]; then
    selected="$reply[$REPLY]"
    print -zr "$selected"
fi

# vim: set filetype=zsh:
}
alias nhistory=n-history

n-kill() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-kill` to .zshrc
#
# This function allows to choose a process and a signal to send to it
#
# Uses n-list

emulate -L zsh

zmodload zsh/curses

setopt localoptions
setopt extendedglob

local IFS="
"

[ -f ~/.config/znt/n-list.conf ] && . ~/.config/znt/n-list.conf

typeset -A signals
signals=(
     1       "1  - HUP"
     2       "2  - INT"
     3       "3  - QUIT"
     6       "6  - ABRT"
     9       "9  - KILL"
     14      "14 - ALRM"
     15      "15 - TERM"
     17      "17 - STOP"
     19      "19 - CONT"
)

local list
local selected
local signal
local -a signal_names
local title

NLIST_REMEMBER_STATE=0

typeset -a NLIST_NONSELECTABLE_ELEMENTS
NLIST_NONSELECTABLE_ELEMENTS=( 1 )

type ps 2>/dev/null 1>&2 || { echo "Error: \`ps' not found"; return 1 }

case "$(uname)" in
    CYGWIN*) list=( `command ps -Wa` )  ;;
    *) list=( `command ps -o pid,uid,command -A` ) ;;
esac

# Ask of PID
title=$'\x1b[00;31m'"${list[1]}"$'\x1b[00;00m'
shift list
list=( "$title" "${(@M)list:#(#i)*$1*}" )

local NLIST_GREP_STRING="$1"

if [ "$#list" -eq 1 ]; then
    echo "No matching processes"
    return 1
fi

n-list "$list[@]"

# Got answer? (could be Ctrl-C or 'q')
if [ "$REPLY" -gt 0 ]; then
    selected="$reply[$REPLY]"
    selected="${selected## #}"
    pid="${selected%% *}"

    # Now ask of signal
    signal_names=( ${(vin)signals} )
    typeset -a NLIST_HOP_INDEXES
    NLIST_HOP_INDEXES=( 3 6 8 )
    n-list $'\x1b[00;31mSelect signal:\x1b[00;00m' "$signal_names[@]"

    if [ "$REPLY" -gt 0 ]; then
        selected="$reply[$REPLY]"
        signal="${(k)signals[(r)$selected]}"

        # Will change so that the command actually
        # executes when function is more tested
        print -zr "kill -$signal $pid"
    fi
fi

# vim: set filetype=zsh:
}
alias nkill=n-kill

n-list() {
# $1, $2, ... - elements of the list
# $NLIST_NONSELECTABLE_ELEMENTS - array of indexes (1-based) that cannot be selected
# $REPLY is the output variable - contains index (1-based) or -1 when no selection
#
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-list` to .zshrc
#
# This function outputs a list of elements that can be
# navigated with keyboard. Uses curses library

emulate -LR zsh

setopt localoptions typesetsilent localtraps extendedglob noshortloops

zmodload zsh/curses

trap "return" TERM INT QUIT
trap "_nlist_exit" EXIT

# Drawing and input
autoload n-list-draw n-list-input

# Cleanup before any exit
_nlist_exit() {
    [[ "$REPLY" = <-> ]] || REPLY="-1"
    zcurses 2>/dev/null delwin inner
    zcurses 2>/dev/null delwin main
    zcurses 2>/dev/null refresh
    zcurses end
}

# Outputs a message in the bottom of the screen
_nlist_status_msg() {
    # -1 for border, -1 for 0-based indexing
    zcurses move main $(( term_height - 1 - 1 )) 2
    zcurses clear main eol
    zcurses string main "$1"
}

#
# Main code
#

# Check if there is proper input
if [ "$#" -lt 1 ]; then
    echo "Usage: n-list element_1 ..."
    return 1
fi

integer term_height="$LINES"
integer term_width="$COLUMNS"
if [[ "$term_height" -lt 1 || "$term_width" -lt 1 ]]; then
    local stty_out=$( stty size )
    term_height="${stty_out% *}"
    term_width="${stty_out#* }"
fi
integer inner_height=term_height-3
integer inner_width=term_width-2
integer page_height=inner_height
integer page_width=inner_width

typeset -a list col_list
integer last_element=$#
local action
local final_key
integer selection
local prev_search_buffer=""

# Ability to remember the list between calls
if [[ -z "$NLIST_REMEMBER_STATE" || "$NLIST_REMEMBER_STATE" -eq 0 || "$NLIST_REMEMBER_STATE" -eq 2 ]]; then
    NLIST_FROM_WHAT_IDX_LIST_IS_SHOWN=1
    NLIST_CURRENT_IDX=1
    NLIST_IS_SEARCH_MODE=0
    NLIST_SEARCH_BUFFER=""
    NLIST_TEXT_OFFSET=0

    NLIST_USER_CURRENT_IDX=0
    [[ ${NLIST_NONSELECTABLE_ELEMENTS[(r)1]} != 1 ]] && NLIST_USER_CURRENT_IDX=1
    NLIST_USER_LAST_ELEMENT=$(( last_element - $#NLIST_NONSELECTABLE_ELEMENTS ))

    # 2 is init once, then remember
    [ "$NLIST_REMEMBER_STATE" -eq 2 ] && NLIST_REMEMBER_STATE=1
fi

zcurses init
zcurses delwin main 2>/dev/null
zcurses delwin inner 2>/dev/null
zcurses addwin main "$term_height" "$term_width" 0 0
zcurses addwin inner "$inner_height" "$inner_width" 1 1
zcurses bg main white/black
zcurses bg inner white/black

#
# Listening for input
#

local key keypad

# Clear input buffer
zcurses timeout main 0
zcurses input main key keypad
zcurses timeout main -1
key=""
keypad=""

list=( "$@" )
last_element="$#"

while (( 1 )); do
    # Do searching (filtering with string)
    if [ -n "$NLIST_SEARCH_BUFFER" ]; then
        # Compute new list, col_list ?
        if [ "$NLIST_SEARCH_BUFFER" != "$prev_search_buffer" ]; then
            prev_search_buffer="$NLIST_SEARCH_BUFFER"

            list=( "$@" )
            last_element="$#"

            # First remove non-selectable elements
            [ "$#NLIST_NONSELECTABLE_ELEMENTS" -gt 0 ] && for i in "${(nO)NLIST_NONSELECTABLE_ELEMENTS[@]}"; do
                list[$i]=()
            done

            # Next do the filtering
            list=( "${(@M)list:#(#i)*$NLIST_SEARCH_BUFFER*}" )
            last_element="$#list"
            [ "$NLIST_CURRENT_IDX" -gt "$last_element" ] && NLIST_CURRENT_IDX="$last_element"
            [[ "$NLIST_CURRENT_IDX" -eq 0 && "$last_element" -ne 0 ]] && NLIST_CURRENT_IDX=1
            (( NLIST_FROM_WHAT_IDX_LIST_IS_SHOWN=0+((NLIST_CURRENT_IDX-1)/page_height)*page_height+1 ))

            local red=$'\x1b[00;31m' reset=$'\x1b[00;00m'
            col_list=( "${(@)list//(#bi)($NLIST_SEARCH_BUFFER)/$red${match[1]}$reset}" )
        fi

        integer end_idx=$(( NLIST_FROM_WHAT_IDX_LIST_IS_SHOWN + page_height - 1 ))
        [ "$end_idx" -gt "$last_element" ] && end_idx=last_element

        # Output colored list
        n-list-draw "$(( (NLIST_CURRENT_IDX-1) % page_height + 1 ))" \
            "$page_height" "$page_width" 0 1 "$NLIST_TEXT_OFFSET" inner ansi \
            "${(@)col_list[NLIST_FROM_WHAT_IDX_LIST_IS_SHOWN, end_idx]}"
    else
        # There is no search, but there was in previous loop
        # Enter non-search mode with fresh list array
        if [ -n "$prev_search_buffer" ]; then
            prev_search_buffer=""
            list=( "$@" )
            last_element="$#"
        fi

        integer end_idx=$(( NLIST_FROM_WHAT_IDX_LIST_IS_SHOWN + page_height - 1 ))
        [ "$end_idx" -gt "$last_element" ] && end_idx=last_element

        # Output the list
        n-list-draw "$(( (NLIST_CURRENT_IDX-1) % page_height + 1 ))" \
            "$page_height" "$page_width" 0 1 "$NLIST_TEXT_OFFSET" inner ansi \
            "${(@)list[NLIST_FROM_WHAT_IDX_LIST_IS_SHOWN, end_idx]}"
    fi

    if [ "$NLIST_IS_SEARCH_MODE" = "1" ]; then
        _nlist_status_msg "Filtering with: $NLIST_SEARCH_BUFFER"
    elif [[ ${NLIST_NONSELECTABLE_ELEMENTS[(r)$NLIST_CURRENT_IDX]} != $NLIST_CURRENT_IDX ]]; then
        local _txt=""
        [ -n "$NLIST_GREP_STRING" ] && _txt=" [$NLIST_GREP_STRING]"
        _nlist_status_msg "Current #$NLIST_USER_CURRENT_IDX (of #$NLIST_USER_LAST_ELEMENT entries)$_txt"
    else
        _nlist_status_msg ""
    fi

    zcurses border main
    zcurses refresh main inner

    # Wait for input
    zcurses input main key keypad

    # Get the special (i.e. "keypad") key or regular key
    if [ -n "$key" ]; then
        final_key="$key" 
    elif [ -n "$keypad" ]; then
        final_key="$keypad"
    else
        _nlist_status_msg "Inproper input detected"
        zcurses refresh main inner
    fi

    n-list-input "$NLIST_CURRENT_IDX" "$NLIST_FROM_WHAT_IDX_LIST_IS_SHOWN" \
                    "$page_height" "$page_width" "$last_element" "$NLIST_TEXT_OFFSET" \
                    "$final_key" "$NLIST_IS_SEARCH_MODE" "$NLIST_SEARCH_BUFFER"

    selection="$reply[1]"
    action="$reply[2]"
    NLIST_CURRENT_IDX="$reply[3]"
    NLIST_FROM_WHAT_IDX_LIST_IS_SHOWN="$reply[4]"
    NLIST_TEXT_OFFSET="$reply[5]"
    NLIST_IS_SEARCH_MODE="$reply[6]"
    NLIST_SEARCH_BUFFER="$reply[7]"
    NLIST_USER_CURRENT_IDX="$reply[8]"
    NLIST_USER_LAST_ELEMENT="$reply[9]"

    if [ "$action" = "SELECT" ]; then
        REPLY="$selection"
        reply=( "$list[@]" )
        break
    elif [ "$action" = "QUIT" ]; then
        REPLY=-1
        break
    elif [ "$action" = "REDRAW" ]; then
        zcurses clear main redraw
        zcurses clear inner redraw
    fi
done

# vim: set filetype=zsh:
}
alias nlist=n-list

n-list-draw() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-list-draw` to .zshrc

emulate -L zsh

zmodload zsh/curses

setopt localoptions typesetsilent extendedglob

_nlist_expand_tabs() {
    local chunk="$1"
    integer before_len="$2"
    REPLY=""

    while [ -n "$chunk" ]; do
        [[ "$chunk" = (#b)([^$'\t']#)$'\t'(*) ]] && {
            (( all_text_len=((before_len+${#match[1]})/8+1)*8 ))

            REPLY+="${(r:all_text_len-before_len:: :)match[1]}"

            before_len+=all_text_len-before_len
            chunk="$match[2]"
        } || {
            REPLY+="$chunk"
            break
        }
    done
}


_nlist_print_with_ansi() {
    local win="$1" text="$2" out col chunk Xout
    integer text_offset="$3" max_text_len="$4" text_len=0 no_match=0 nochunk_text_len to_skip_from_chunk to_chop_off_from_chunk before_len

    # 1 - non-escaped text, 2 - first number in the escaped text, with ;
    # 3 - second number, 4 - text after whole escape text

    typeset -a c
    c=( black red green yellow blue magenta cyan white )

    while [[ -n "$text" && "$no_match" -eq 0 ]]; do
        if [[ "$text" = (#b)([^$'\x1b']#)$'\x1b'\[(#B)([0-9][0-9]\;|)(#b)([0-9][0-9]|)m(*) ]]; then
            # Text for further processing
            text="$match[3]"
            # Text chunk to output now
            out="$match[1]"
            # Save color
            col="$match[2]"
        else
            out="$text"
            no_match=1
        fi

        if [ -n "$out" ]; then
################ Expand tabs ################
            chunk="$out"
            before_len="$text_len"
            Xout=""

            while [ -n "$chunk" ]; do
                [[ "$chunk" = (#b)([^$'\t']#)$'\t'(*) ]] && {
                    (( all_text_len=((before_len+${#match[1]})/8+1)*8 ))

                    Xout+="${(r:all_text_len-before_len:: :)match[1]}"

                    before_len+=all_text_len-before_len
                    chunk="$match[2]"
                } || {
                    Xout+="$chunk"
                    break
                }
            done
#############################################

            # Input text length without the current chunk
            nochunk_text_len=text_len
            # Input text length up to current chunk
            text_len+="$#Xout"

            # Should start displaying with this chunk?
            # I.e. stop skipping left part of the input text?
            if (( text_len > text_offset )); then
                to_skip_from_chunk=text_offset-nochunk_text_len

                # LEFT - is chunk off the left skip boundary? +1 for 1-based index in string
                (( to_skip_from_chunk > 0 )) && Xout="${Xout[to_skip_from_chunk+1,-1]}"

                # RIGHT - is text off the screen?
                if (( text_len-text_offset > max_text_len )); then
                    to_chop_off_from_chunk=0+(text_len-text_offset)-max_text_len
                    Xout="${Xout[1,-to_chop_off_from_chunk-1]}"
                fi
                
                [ -n "$Xout" ] && zcurses string "$win" "$Xout"
            fi
        fi

        if (( no_match == 0 )); then
            if (( col >= 30 && col <= 37 )); then
                zcurses attr "$win" $c[col-29]/black
            elif [[ "$col" -eq 0 ]]; then
                zcurses attr "$win" white/black
            fi
        fi
    done
}

integer highlight="$1"
integer page_height="$2"
integer page_width="$3"
local y_offset="$4"
local x_offset="$5"
local text_offset="$6"
local win="$7"
local ansi_mode="$8"
shift 8
integer max_text_len=page_width-x_offset

[ "$bold" = "0" ] && bold="" || bold="+bold"
[ "$ansi_mode" = "ansi" ] && zcurses attr "$win" $bold white/black

integer end_idx=1+page_height-1
[ "$end_idx" -gt "$#" ] && end_idx="$#"
integer y=y_offset

integer i text_len
local text
for (( i=1; i<=end_idx; i++ )); do
    zcurses move "$win" $y "$x_offset"

    [ "$i" = "$highlight" ] && zcurses attr "$win" +reverse
    if [ "$ansi_mode" != "ansi" ]; then
        # TODO horizontal scroll
        _nlist_expand_tabs "$@[i]"
        text="$REPLY"
        text_len="${#text}"

        [ "$text_len" -gt "$max_text_len" ] && text="${text[1,$max_text_len]}"
        zcurses string "$win" "$text"
    else
        _nlist_print_with_ansi "$win" "$@[i]" "$text_offset" "$max_text_len"
    fi
    [ "$i" = "$highlight" ] && zcurses attr "$win" -reverse

    y+=1
done

zcurses attr "$win" white/black
# vim: set filetype=zsh:
}
alias nlist-draw=n-list-draw

n-list-input() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-list-input` to .zshrc

emulate -L zsh

zmodload zsh/curses

setopt localoptions
setopt typesetsilent

# Compute first to show index
_nlist_compute_first_to_show_idx() {
    from_what_idx_list_is_shown=0+((current_idx-1)/page_height)*page_height+1
}

_nlist_compute_user_vars_difference() {
        if [[ "${(t)NLIST_NONSELECTABLE_ELEMENTS}" != "array" &&
                "${(t)NLIST_NONSELECTABLE_ELEMENTS}" != "array-local" ||
                -n "$buffer" ]]
        then
            last_element_difference=0
            current_difference=0
        else
            last_element_difference=$#NLIST_NONSELECTABLE_ELEMENTS
            current_difference=0
            local idx
            for idx in "${(n)NLIST_NONSELECTABLE_ELEMENTS[@]}"; do
                [ "$idx" -le "$current_idx" ] && current_difference+=1 || break
            done
        fi
}

integer current_difference
integer last_element_difference
typeset -ga reply
reply=( -1 '' 1 1 )
integer current_idx="$1"
integer from_what_idx_list_is_shown="$2"
integer page_height="$3"
integer page_width="$4"
integer last_element="$5"
integer hscroll="$6"
local key="$7"
integer search="$8"
local buffer="$9"

#
# Listening for input
#

if [ "$search" = "0" ]; then

case "$key" in
    (UP|k|)
        # Are there any elements before the current one?
        [ "$current_idx" -gt 1 ] && current_idx=current_idx-1;
        _nlist_compute_first_to_show_idx
        ;;
    (DOWN|j|)
        # Are there any elements after the current one?
        [ "$current_idx" -lt "$last_element" ] && current_idx=current_idx+1;
        _nlist_compute_first_to_show_idx
        ;;
    (PPAGE)
        current_idx=current_idx-page_height
        [ "$current_idx" -lt 1 ] && current_idx=1;
        _nlist_compute_first_to_show_idx
        ;;
    (NPAGE|" ")
        current_idx=current_idx+page_height
        [ "$current_idx" -gt "$last_element" ] && current_idx=last_element;
        _nlist_compute_first_to_show_idx
        ;;
    ()
        current_idx=current_idx-page_height/2
        [ "$current_idx" -lt 1 ] && current_idx=1;
        _nlist_compute_first_to_show_idx
        ;;
    ()
        current_idx=current_idx+page_height/2
        [ "$current_idx" -gt "$last_element" ] && current_idx=last_element;
        _nlist_compute_first_to_show_idx
        ;;
    (HOME|g)
        current_idx=1
        _nlist_compute_first_to_show_idx
        ;;
    (END|G)
        current_idx=last_element
        _nlist_compute_first_to_show_idx
        ;;
    ($'\n')
        # Is that element selectable?
        # Check for this only when there is no search
        if [[ "$NLIST_SEARCH_BUFFER" != "" || ${NLIST_NONSELECTABLE_ELEMENTS[(r)$current_idx]} != $current_idx ]]; then
            # Save current element in the result variable
            reply=( $current_idx SELECT )
        fi
        ;;
    (q)
            reply=( -1 QUIT )
        ;;
    (/)
        search=1
        ;;
    ($'\t')
            reply=( $current_idx LEAVE )
        ;;
    ()
        reply=( -1 REDRAW )
        ;;
    (\])
        [[ "${(t)NLIST_HOP_INDEXES}" = "array" || "${(t)NLIST_HOP_INDEXES}" = "array-local" ]] &&
        [ -z "$NLIST_SEARCH_BUFFER" ] && for idx in "${(n)NLIST_HOP_INDEXES[@]}"; do
            if [ "$idx" -gt "$current_idx" ]; then
                current_idx=$idx
                _nlist_compute_first_to_show_idx
                break
            fi
        done
        ;;
    (\[)
        [[ "${(t)NLIST_HOP_INDEXES}" = "array" || "${(t)NLIST_HOP_INDEXES}" = "array-local" ]] &&
        [ -z "$NLIST_SEARCH_BUFFER" ] && for idx in "${(nO)NLIST_HOP_INDEXES[@]}"; do
            if [ "$idx" -lt "$current_idx" ]; then
                current_idx=$idx
                _nlist_compute_first_to_show_idx
                break
            fi
        done
        ;;
    ('<'|'{')
        hscroll=hscroll-7
        [ "$hscroll" -lt 0 ] && hscroll=0
        ;;
    ('>'|'}')
        hscroll+=7
        ;;
    (*)
        ;;
esac

else

case "$key" in
    ($'\n')
        search=0
        ;;
    ($'\b'||BACKSPACE)
        buffer="${buffer%?}"
        ;;
    ()
        [ "$buffer" = "${buffer% *}" ] && buffer="" || buffer="${buffer% *}"
        ;;
    (*)
        buffer+="$key"
        ;;
esac

reply=( -1 SEARCH )

fi

_nlist_compute_user_vars_difference

reply[3]="$current_idx"
reply[4]="$from_what_idx_list_is_shown"
reply[5]="$hscroll"
reply[6]="$search"
reply[7]="$buffer"
reply[8]=$(( current_idx - current_difference ))
reply[9]=$(( last_element - last_element_difference ))

# vim: set filetype=zsh:
}
alias nlist-input=n-list-input

n-options() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-options` to .zshrc
#
# This function allows to browse and toggle shell's options
#
# Uses n-list

#emulate -L zsh

zmodload zsh/curses

local IFS="
"

[ -f ~/.config/znt/n-list.conf ] && . ~/.config/znt/n-list.conf

# TODO restore options
unsetopt localoptions
setopt kshoptionprint

local list
local selected
local option
local state

# 0 - don't remember, 1 - remember, 2 - init once, then remember
NLIST_REMEMBER_STATE=2

local NLIST_GREP_STRING="${1:=}"

while (( 1 )); do
    list=( `setopt` )
    list=( "${(M)list[@]:#*${1:=}*}" )

    if [ "$#list" -eq 0 ]; then
        echo "No matching options"
        break
    fi

    local red=$'\x1b[00;31m' green=$'\x1b[00;32m' reset=$'\x1b[00;00m'
    list=( "${list[@]/ off/${red} off$reset}" )
    #list=( "${list[@]/ on/${green} on$reset}" )
    list=( "${(i)list[@]}" )

    n-list "${list[@]}"

    if [ "$REPLY" -gt 0 ]; then
        [[ -o ksharrays ]] && selected="${reply[$(( REPLY - 1 ))]}" || selected="${reply[$REPLY]}"
        option="${selected%% *}"
        state="${selected##* }"

        if [[ -o globsubst ]]; then
            unsetopt globsubst
            state="${state%$reset}"
            setopt globsubst
        else
            state="${state%$reset}"
        fi

        # Toggle the option
        if [ "$state" = "on" ]; then
            echo "Setting |$option| to off"
            unsetopt "$option"
        else
            echo "Setting |$option| to on"
            setopt "$option"
        fi
    else
        break
    fi
done

NLIST_REMEMBER_STATE=0

# vim: set filetype=zsh:
}
alias noptions=n-options

n-panelize() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-panelize` to .zshrc
#
# This function somewhat reminds the panelize feature from Midnight Commander
# It allows browsing output of arbitrary command. Example usage:
# v-panelize ls /usr/local/bin
#
# Uses n-list

emulate -L zsh

zmodload zsh/curses

local IFS="
"

[ -f ~/.config/znt/n-list.conf ] && . ~/.config/znt/n-list.conf

local list
local selected

NLIST_REMEMBER_STATE=0

# Check if there is proper input
if [ "$#" -lt 1 ]; then
    echo "Usage: n-panelize command ..."
    return 1
fi

list=( `"$@"` )
[ "$?" -ne 0 ] && return $?

n-list "${list[@]}"

if [ "$REPLY" -gt 0 ]; then
    selected="$reply[$REPLY]"
    echo "You have selected $selected"
fi

# vim: set filetype=zsh:
}
alias npanelize=n-panelize

n-preview() {
# Copy this file into /usr/share/zsh/site-functions/
# and add 'autoload n-preview` to .zshrc
#
# This is partially a test if n-list-draw and n-list-input can be
# used multiple times to create multiple lists. It might become
# more usable if someone adds more features like previewing of
# archive contents.

emulate -L zsh

zmodload zsh/curses

setopt localoptions typesetsilent localtraps extendedglob
trap "return" TERM INT QUIT
trap "_vpreview_exit" EXIT

local IFS="
"

[ -f ~/.config/znt/n-list.conf ] && . ~/.config/znt/n-list.conf

# Drawing and input
autoload n-list-draw n-list-input

# Cleanup before any exit
_vpreview_exit() {
    zcurses 2>/dev/null delwin files
    zcurses 2>/dev/null delwin body 
    zcurses 2>/dev/null delwin status
    zcurses 2>/dev/null refresh
    zcurses end
}

# Outputs a message in the bottom of the screen
_vpreview_status_msg() {
    zcurses move status 1 2
    zcurses clear status eol
    zcurses string status "$1"
}

#
# Main code
#

integer term_height="$LINES"
integer term_width="$COLUMNS"
if [[ "$term_height" -lt 1 || "$term_width" -lt 1 ]]; then
    local stty_out=$( stty size )
    term_height="${stty_out% *}"
    term_width="${stty_out#* }"
fi

integer status_height=3
integer status_width=term_width
integer status_page_height=1
integer status_page_width=term_width-2

integer files_height=term_height-status_height
integer files_width=term_width/5
integer files_page_height=files_height-2
integer files_page_width=files_width-2

integer body_height=term_height-status_height
integer body_width=term_width-files_width
integer body_page_height=body_height-2
integer body_page_width=body_width

integer _from_what_idx_list_is_shown_1=1
integer current_1=1

integer _from_what_idx_list_is_shown_2=1
integer current_2=1
integer hscroll_2=0

integer active_window=0

local ansi_mode="ansi"
[ -f ~/.config/znt/n-preview.conf ] && . ~/.config/znt/n-preview.conf
typeset -a hcmd
#if type pygmentize 2>/dev/null 1>&2; then
#    hcmd=( pygmentize -g )
if type highlight 2>/dev/null 1>&2; then
    hcmd=( highlight -q --force -O ansi )
elif type source-highlight 2>/dev/null 1>&2; then
    # Warning: source-highlight can have problems
    hcmd=( source-highlight --failsafe -fesc -o STDOUT -i )
else
    ansi_mode="noansi"
fi

zcurses init
zcurses addwin status "$status_height" "$status_width" $(( term_height - status_height )) 0
zcurses addwin files "$files_height" "$files_width" 0 0
zcurses addwin body "$body_height" "$body_width" 0 "$files_width"
zcurses bg status white/black
zcurses bg files white/black
zcurses bg body white/black

#
# Listening for input
#

local key keypad

# Clear input buffer
zcurses timeout status 0
zcurses input status key keypad
zcurses timeout status -1
key=""
keypad=""

typeset -a filenames
integer last_element_1

typeset -a body
integer last_element_2

filenames=( *(N) )
filenames=( "${(@M)filenames:#(#i)*$1*}" )

local NLIST_GREP_STRING="$1"

integer last_element_1="$#filenames"
integer last_element_2=0

local selection action final_key

while (( 1 )); do
    # Output the lists
    integer end_idx=$(( _from_what_idx_list_is_shown_1 + files_page_height - 1 ))
    [ "$end_idx" -gt "$last_element_1" ] && end_idx=last_element_1

    n-list-draw "$(( (current_1 -1) % files_page_height + 1 ))" \
                    "$files_page_height" "$files_page_width" 1 2 0 files noansi \
                    "${(@)filenames[_from_what_idx_list_is_shown_1, end_idx]}"

    if [ "$#body" -ge 1 ]; then
        end_idx=$(( _from_what_idx_list_is_shown_2 + body_page_height - 1 ))
        [ "$end_idx" -gt "$last_element_2" ] && end_idx=last_element_2

        n-list-draw "$(( (current_2 -1) % body_page_height + 1 ))" \
                        "$body_page_height" "$body_page_width" 1 0 "$hscroll_2" body "$ansi_mode" \
                        "${(@)body[_from_what_idx_list_is_shown_2, end_idx]}"
    fi

    [[ "$active_window" -eq 0 ]] && zcurses border files
    zcurses border status
    zcurses refresh files body status 

    # Wait for input
    zcurses input status key keypad

    # Get the special (i.e. "keypad") key or regular key
    if [ -n "$key" ]; then
        final_key="$key" 
    elif [ -n "$keypad" ]; then
        final_key="$keypad"
    else
        _vpreview_status_msg "Inproper input detected"
        zcurses refresh status 
    fi

    if [ "$active_window" -eq 0 ]; then
        zcurses clear files
        n-list-input "$current_1" "$_from_what_idx_list_is_shown_1" "$files_page_height" \
            "$files_page_width" "$last_element_1" 0 "$final_key"

        selection="$reply[1]"
        action="$reply[2]"
        current_1="$reply[3]"
        _from_what_idx_list_is_shown_1="$reply[4]"

        if [ "$action" = "SELECT" ]; then
            # Load new file and refresh the displaying window
            local filename="$filenames[$selection]"
            if [ "$ansi_mode" = "ansi" ]; then
                body=( "${(@f)"$( "$hcmd[@]" "$filename" )"}" )
            else
                body=( "${(@f)"$(<$filename)"}" )
            fi
            last_element_2="$#body"
            current_2=1
            _from_what_idx_list_is_shown_2=1
            zcurses clear body
        fi
    elif [ "$active_window" -eq 1 ]; then
        zcurses clear body
        n-list-input "$current_2" "$_from_what_idx_list_is_shown_2" "$body_page_height" \
            "$body_page_width" "$last_element_2" "$hscroll_2" "$final_key"

        selection="$reply[1]"
        action="$reply[2]"
        current_2="$reply[3]"
        _from_what_idx_list_is_shown_2="$reply[4]"
        hscroll_2="$reply[5]"

    fi

    if [ "$action" = "LEAVE" ]; then
        active_window=1-active_window
    elif [ "$action" = "QUIT" ]; then
            break
    elif [ "$action" = "REDRAW" ]; then
        zcurses clear files redraw
        zcurses clear body redraw
        zcurses clear status redraw
    fi
done

# vim: set filetype=zsh:
}
alias npreview=n-preview

