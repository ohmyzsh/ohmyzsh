# If there is no PATHRC already set, default to ~/.pathrc
if [ -z "$PATHRC" ]; then
    PATHRC=$HOME/.pathrc
fi

# Similarly, MANPATHRC defaults to ~/.manpath
if [ -z "$MANPATHRC" ]; then
    MANPATHRC=$HOME/.manpathrc
fi

# Set the PATH
if [ -f $PATHRC ]; then
    path=()
    typeset -U path
    for dir in $(<$PATHRC); do 
        path+=($dir)
    done 
fi 

# Set the MANPATH
if [ -f $MANPATHRC ]; then
    manpath=()
    typeset -U manpath
    for dir in $(<$MANPATHRC); do
        manpath+=($dir)
    done 
fi
