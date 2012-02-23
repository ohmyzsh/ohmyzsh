export EMACS_APP="/Applications/Emacs.app"

# open in background, eventually using running app
export EDITOR="open -a $EMACS_APP"

# always open new app, wait until closed
export GIT_EDITOR="open -n -W -a $EMACS_APP"

alias em="$EDITOR"

# workaround b/c Emacs can only open already existing files
function _emacs_touch_and_edit() {
    touch $*
    eval $EDITOR $*
}
alias emt=_emacs_touch_and_edit
