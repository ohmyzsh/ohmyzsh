if [ "$OSTYPE[0,7]" = "solaris" ]
then
    if [ ! -x ${HOME}/bin/nroff ]
    then
        mkdir -p ${HOME}/bin
        cat > ${HOME}/bin/nroff <<EOF
#!/bin/sh
if [ -n "\$_NROFF_U" -a "\$1,\$2,\$3" = "-u0,-Tlp,-man" ]; then
    shift
    exec /usr/bin/nroff -u\${_NROFF_U} "\$@"
fi
#-- Some other invocation of nroff
exec /usr/bin/nroff "\$@"
EOF
    chmod +x ${HOME}/bin/nroff
    fi
fi

zstyle :omz:plugins:colored-man mb $(printf "\e[1;31m")
zstyle :omz:plugins:colored-man md $(printf "\e[1;31m")
zstyle :omz:plugins:colored-man me $(printf "\e[0m")
zstyle :omz:plugins:colored-man se $(printf "\e[0m")
zstyle :omz:plugins:colored-man so $(printf "\e[1;44;33m")
zstyle :omz:plugins:colored-man ue $(printf "\e[0m")
zstyle :omz:plugins:colored-man us $(printf "\e[1;32m")

man() {
    local _mb _md _me _se _so _ue _us

    zstyle -s :omz:plugins:colored-man mb _mb
    zstyle -s :omz:plugins:colored-man md _md
    zstyle -s :omz:plugins:colored-man me _me
    zstyle -s :omz:plugins:colored-man se _se
    zstyle -s :omz:plugins:colored-man so _so
    zstyle -s :omz:plugins:colored-man ue _ue
    zstyle -s :omz:plugins:colored-man us _us

    env \
      LESS_TERMCAP_mb=$_mb\
      LESS_TERMCAP_md=$_md\
      LESS_TERMCAP_me=$_me\
      LESS_TERMCAP_se=$_se\
      LESS_TERMCAP_so=$_so\
      LESS_TERMCAP_ue=$_ue\
      LESS_TERMCAP_us=$_us\
      PAGER=/usr/bin/less \
      _NROFF_U=1 \
      PATH=${HOME}/bin:${PATH} \
                     man "$@"
}
