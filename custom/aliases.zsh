SYSTEM=$(uname -s)
if [ ${SYSTEM} = "NetBSD" ];then
    if [ -x /usr/pkg/bin/gls ];then
        alias ls='/usr/pkg/bin/gls --color=tty -F'
    else
        alias ls='ls -F'
    fi
elif [ ${SYSTEM} = "FreeBSD" ];then
    alias ls='ls -FG'
else
    alias ls='ls --color=tty -F'
fi
EMACS_SOCKET=emacs1
if [[ -n $INSIDE_EMACS ]];then
    alias e="emacsclient -s ${EMACS_SOCKET} -n"
    alias ec="emacsclient -s ${EMACS_SOCKET} -n"
    alias vi="emacsclient -s ${EMACS_SOCKET} -n"
    alias dir="emacsclient -s -s ${EMACS_SOCKET} -ne '(dired \"./\")'"
else
    alias e="emacsclient -s ${EMACS_SOCKET} -tc"
    alias ec="emacsclient -s ${EMACS_SOCKET} -nc"
fi

if [[ -n $(which rlwrap) ]];then
    if  [[ -n $(which sbcl 2>/dev/null) ]];then
        alias sbcl='rlwrap sbcl'
    fi
    if [[ -n $(which ros 2>/dev/null) ]];then
        alias lisp='rlwrap ros run'
    fi
fi

GPG_TTY=$(tty);export GPG_TTY

