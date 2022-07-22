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

alias y='"$GREP" -Ri'
alias n='"$GREP" -Rvi'

alias f.='find . | "$GREP"'
alias f:='find'

alias f='"$GREP" -Rli'
alias fn='"$GREP" -Rlvi'

alias w='echo >'
alias a='echo >>'

alias c='cat'
alias p='"$PAGER"'

alias m='man'

alias d='"$WGET"'
alias u='"$CURL"'

# enhanced writing

alias w:='cat >'
alias a:='cat >>'

# XARGS

alias x='xargs'

alias xy='xargs "$GREP" -Ri'
alias xn='xargs "$GREP" -Riv'

alias xf.='xargs find | "$GREP"'
alias xf:='xargs find'

alias xf='xargs "$GREP" -Rli'
alias xfn='xargs "$GREP" -Rlvi'

alias xw='xargs echo >'
alias xa='xargs echo >>'

alias xc='xargs cat'
alias xp='xargs "$PAGER"'

alias xm='xargs man'

alias xd='xargs "$WGET"'
alias xu='xargs "$CURL"'

alias xw:='xargs cat >'
alias xa:='xargs >>'

# SUDO

alias s='"$ROOT"'

alias sy='"$ROOT" "$GREP" -Ri'
alias sn='"$ROOT" "$GREP" -Riv'

alias sf.='"$ROOT" find . | "$GREP"'
alias sf:='"$ROOT" find'

alias sf='"$ROOT" "$GREP" -Rli'
alias sfn='"$ROOT" "$GREP" -Rlvi'

alias sw='"$ROOT" echo >'
alias sa='"$ROOT" echo >>'

alias sc='"$ROOT" cat'
alias sp='"$ROOT" "$PAGER"'

alias sm='"$ROOT" man'

alias sd='"$ROOT" "$WGET"'

alias sw:='"$ROOT" cat >'
alias sa:='"$ROOT" cat >>'

# SUDO-XARGS

alias sx='"$ROOT" xargs'

alias sxy='"$ROOT" xargs "$GREP" -Ri'
alias sxn='"$ROOT" xargs "$GREP" -Riv'

alias sxf.='"$ROOT" xargs find | "$GREP"'
alias sxf:='"$ROOT" xargs find'

alias sxf='"$ROOT" xargs "$GREP" -li'
alias sxfn='"$ROOT" xargs "$GREP" -lvi'

alias sxw='"$ROOT" xargs echo >'
alias sxa='"$ROOT" xargs echo >>'

alias sxc='"$ROOT" xargs cat'
alias sxp='"$ROOT" xargs "$PAGER"'

alias sxm='"$ROOT" xargs man'

alias sxd='"$ROOT" xargs "$WGET"'
alias sxu='"$ROOT" xargs "$CURL"'

alias sxw:='"$ROOT" xargs cat >'
alias sxa:='"$ROOT" xargs cat >>'
