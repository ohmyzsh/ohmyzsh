###########################
# Settings 
#
# These can be overwritten any time.
# If they are not set yet, they will be
# overwritten with their default values

default GREP grep
default ROOT sudo

###########################
# Alias

alias y='"$GREP" -i'
alias n='"$GREP" -vi'

alias x='xargs'
alias xy='xargs "$GREP" -i'
alias xn='xargs "$GREP" -iv'

alias s='"$ROOT"'
alias sx='"$ROOT" xargs'
alias sxy='"$ROOT" xargs "$GREP" -i'
alias sxn='"$ROOT" xargs "$GREP" -iv'