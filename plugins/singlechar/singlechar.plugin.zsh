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

env_defaul PAGER less

###########################
# Alias

# CAT, GREP, CURL, WGET

alias y='"$GREP" -i'
alias n='"$GREP" -vi'

alias c='cat'
alias w='cat >'
alias a='cat >>'

alias p='"$PAGER"'

alias d='"$WGET"'
alias u='"$CURL"'

# XARGS

alias x='xargs'

alias xy='xargs "$GREP" -i'
alias xn='xargs "$GREP" -iv'

alias xc='xargs cat'
alias xw='xargs cat >'
alias xa='xargs cat >>'

alias xp='xargs "$PAGER"'

alias xd='xargs "$WGET"'
alias xu='xargs "$CURL"'

# SUDO

alias s='"$ROOT"'

alias sx='"$ROOT" xargs'

alias sxy='"$ROOT" xargs "$GREP" -i'
alias sxn='"$ROOT" xargs "$GREP" -iv'

alias sxc='"$ROOT" xargs cat'
alias sxw='"$ROOT" xargs cat >'
alias sxa='"$ROOT" xargs cat >>'

alias sxp='"$ROOT" xargs "$PAGER"'

alias sxd='"$ROOT" xargs "$WGET"'
alias sxu='"$ROOT" xargs "$CURL"'