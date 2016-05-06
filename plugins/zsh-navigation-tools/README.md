# Zsh Navigation Tools

http://imageshack.com/a/img633/7967/ps6rKR.png

Set of tools like n-history – multi-word history searcher, n-cd – directory
bookmark manager, n-kill – htop like kill utility, and more. Based on
n-list, a tool generating selectable curses-based list of elements that has
access to current Zsh session, i.e. has broad capabilities to work together
with it. Feature highlights include incremental multi-word searching, ANSI
coloring, unique mode, horizontal scroll, non-selectable elements, grepping and
various integrations with Zsh.

## History Widget

To have n-history as multi-word incremental searcher bound to Ctrl-R copy znt-*
files into the */site-functions dir (unless you use Oh My Zsh) and
add:

    autoload znt-history-widget
    zle -N znt-history-widget
    bindkey "^R" znt-history-widget

to .zshrc. This is done automatically when using Oh My Zsh. Two other
widgets exist, znt-cd-widget and znt-kill-widget, they can be too assigned
to key combinations (no need for autoload when using Oh My Zsh):

    zle -N znt-cd-widget
    bindkey "^A" znt-cd-widget
    zle -N znt-kill-widget
    bindkey "^Y" znt-kill-widget

Oh My Zsh stores history into ~/.zsh_history. When you switch to OMZ you could
want to copy your previous data (from e.g. ~/.zhistory) into the new location.

## Introduction

The tools are:

- n-aliases - browses aliases, relegates editing to vared
- n-cd - browses dirstack and bookmarked directories, allows to enter selected directory
- n-functions - browses functions, relegates editing to zed or vared
- n-history - browses history, allows to edit and run commands from it
- n-kill - browses processes list, allows to send signal to selected process
- n-env - browses environment, relegates editing to vared
- n-options - browses options, allows to toggle their state
- n-panelize - loads output of given command into the list for browsing

All tools support horizontal scroll with <,>, {,}, h,l or left and right
cursors. Other keys are:

- [,] - jump directory bookmarks in n-cd and typical signals in n-kill
- Ctrl-d, Ctrl-u - half page up or down
- Ctrl-p, Ctrl-n - previous and next (also done with vim's j,k)
- Ctrl-l - redraw of whole display
- g, G - beginning and end of the list
- Ctrl-o, o - enter uniq mode (no duplicate lines)
- / - start incremental search
- Enter - finish incremental search, retaining filter
- Esc - exit incremental search, clearing filter
- Ctrl-w (in incremental search) - delete whole word
- Ctrl-k (in incremental search) - delete whole line

## Programming

The function n-list is used as follows:

    n-list {element1} [element2] ... [elementN]

This is all that is needed to be done to have the features like ANSI coloring,
incremental multi-word search, unique mode, horizontal scroll, non-selectable
elements (grepping is done outside n-list, see the tools for how it can be
done). To set up non-selectable entries add their indices into array
NLIST_NONSELECTABLE_ELEMENTS:

    typeset -a NLIST_NONSELECTABLE_ELEMENTS
    NLIST_NONSELECTABLE_ELEMENTS=( 1 )

Result is stored as $reply[REPLY] ($ isn't needed before REPLY because
of arithmetic context inside []). The returned array might be different from
input arguments as n-list can process them via incremental search or uniq
mode. $REPLY is the index in that possibly processed array. If $REPLY
equals -1 it means that no selection have been made (user quitted via q
key).

To set up entries that can be jumped to with [,] keys add their indices to
NLIST_HOP_INDEXES array:

    typeset -a NLIST_HOP_INDEXES
    NLIST_HOP_INDEXES=( 1 10 )

n-list can automatically colorize entries according to a Zsh pattern.
Following example will colorize all numbers with blue:

    local NLIST_COLORING_PATTERN="[0-9]##"
    local NLIST_COLORING_COLOR=$'\x1b[00;34m'
    local NLIST_COLORING_END_COLOR=$'\x1b[0m'
    local NLIST_COLORING_MATCH_MULTIPLE=1
    n-list "This is a number 123" "This line too has a number: 456"

Blue is the default color, it doesn't have to be set. See zshexpn man page
for more information on Zsh patterns. Briefly, comparing to regular
expressions, (#s) is ^, (#e) is $, # is *, ## is +. Alternative
will work when in parenthesis, i.e. (a|b). BTW by using this method you can
colorize output of the tools, via their config files (check out e.g. n-cd.conf,
it uses this).

## Performance
ZNT are fastest with Zsh before 5.0.6 and starting from 5.2


vim:filetype=conf
