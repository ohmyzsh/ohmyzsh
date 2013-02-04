#!/bin/zsh

# Emacs
function em() {
   emacs $@ &>/dev/null &!
}

# Emacs client
function emc() {
   emacsclient -n $@
}
