# create temp dir, move into, and clean

mktempdir() {
    if [[ ! -z $TEMP_DIR ]]
    then
        >&2 echo "Temp dir exists. Clean it first via \`rmtempdir\` ("$TEMP_DIR")."
    else
        export TEMP_DIR=`/bin/mktemp -d` TEMP_CWD=`pwd`
        cd $TEMP_DIR
    fi
}

rmtempdir() {
    if [[ -z $TEMP_DIR ]]
    then
        >&2 echo "Temp dir does not exist."
    else
        cd $TEMP_CWD
        /bin/rm -rf $TEMP_DIR
        unset TEMP_DIR TEMP_CWD
    fi
}

dumptempdir() {
    if [[ -z $TEMP_DIR ]]
    then
        >&2 echo "Temp dir does not exist."
    elif [[ -z $1 ]]
    then
        >&2 echo "No destination specified."
    else
        /bin/mkdir -p $1
        /bin/cp -r $TEMP_DIR/* $1
    fi
}

alias mktmpdir=mktempdir
alias rmtmpdir=rmtempdir
alias dumptmpdir=dumptempdir
