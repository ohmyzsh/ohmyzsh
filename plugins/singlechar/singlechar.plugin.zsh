################################################################################
#          FILE:  singlechar.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Michael Varner (musikmichael@web.de)
#       VERSION:  1.0.0
#
# This plugin adds single char shortcuts (and combinations) for some commands.
#
################################################################################

###########################
# Settings 

# These can be overwritten any time.
# If they are not set yet, they will be
# overwritten with their default values

default GREP grep
default ROOT sudo
default WGET wget
default CURL curl

env_default PAGER less

###########################
# Alias

# CAT, GREP, CURL, WGET

alias y='"$GREP" -i'
alias n='"$GREP" -vi'

alias w='echo >'
alias a='echo >>'

alias c='cat'
alias p='"$PAGER"'

alias d='"$WGET"'
alias u='"$CURL"'

# enhanced writeing

alias w:='cat >'
alias a:='cat >>'

# XARGS

alias x='xargs'

alias xy='xargs "$GREP" -i'
alias xn='xargs "$GREP" -iv'

alias xw='xargs echo >'
alias xa='xargs echo >>'

alias xc='xargs cat'
alias xp='xargs "$PAGER"'

alias xd='xargs "$WGET"'
alias xu='xargs "$CURL"'

alias xw:='xargs cat >'
alias xa:='xargs >>'

# SUDO

alias s='"$ROOT"'

alias sy='"$ROOT" "$GREP" -i'
alias sn='"$ROOT" "$GREP" -iv'

alias sw='"$ROOT" echo >'
alias sa='"$ROOT" echo >>'

alias sc='"$ROOT" cat'
alias sp='"$ROOT" "$PAGER"'

alias sd='"$ROOT" "$WGET"'

alias sw:='"$ROOT" cat >'
alias sa:='"$ROOT" cat >>'

# SUDO-XARGS

alias sx='"$ROOT" xargs'

alias sxy='"$ROOT" xargs "$GREP" -i'
alias sxn='"$ROOT" xargs "$GREP" -iv'

alias sxw='"$ROOT" xargs echo >'
alias sxa='"$ROOT" xargs echo >>'

alias sxc='"$ROOT" xargs cat'
alias sxp='"$ROOT" xargs "$PAGER"'

alias sxd='"$ROOT" xargs "$WGET"'
alias sxu='"$ROOT" xargs "$CURL"'

alias sxw:='"$ROOT" xargs cat >'
alias sxa:='"$ROOT" xargs cat >>'