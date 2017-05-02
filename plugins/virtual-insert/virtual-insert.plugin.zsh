zle -N user-complete
bindkey "\t" user-complete

zle -N user-ret
bindkey "\r" user-ret

zle -N user-del
bindkey "^W" user-del        

cdpath=".."

user-complete()
{
    case $BUFFER in
        "" )
            BUFFER="cd "
            zle end-of-line
            zle expand-or-complete
            ;;
        cd\ \ * )
            BUFFER=${BUFFER/\ \ /\ ~}
            zle end-of-line
            zle expand-or-complete
            ;;
        " " )
            BUFFER="z "
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd --" )
            BUFFER="cd +"
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd +-" )
            BUFFER="cd -"
            zle end-of-line
            zle expand-or-complete
            ;;
        * )
            zle expand-or-complete
            ;;
    esac
}

user-ret()
{
    if [[ $BUFFER = "" ]] ;then
        BUFFER="ls"
        zle end-of-line
        zle accept-line
    elif [[ $BUFFER =~ "^cd\ \.\.\.+$" ]] ;then
        BUFFER=${${BUFFER//\./\.\.\/}/\.\.\//}
        zle end-of-line
        zle accept-line
    else
        zle accept-line
    fi
}

user-del()
{
    if [[ $BUFFER = "" ]] ; then
        BUFFER="cd .."
        zle end-of-line
        zle accept-line
    else
        zle backward-kill-word
    fi
}
