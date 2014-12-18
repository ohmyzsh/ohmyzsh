# Quick touch file and exec chmod command

# If the arguments is only one
# 1. it not exist before,then create it and edit it auto,else 
# 2. else,chmod it
#
# else if there are many arguments chmod all of them and edit 
# or not as you choice,default edit is vim.If no argument given
# or only option you can chmod file stilly.
#
# Example: x -e vim test.md test1.md
function x {
    local EDIT=vim
    local V
    local HELP
    local FILES
    # No args given
    [ $# -eq 0 ] && \
        read -p "Which file(s) you want give it(them) privilege?\n`ls`" choice
    if [ -z $choice ]; then
        return 0
    else
        _xfile $@
    fi
    # Args is given and config local argvs
    for item in $@; do
        case $item in 
            -h)
                HELP=yes;;
            -e)
                if `which $2`; then
                    EDIT=$2
                fi
                shift;;
            -v)
                V=yes;;
            *)
                FILES="$item $FILES"
        esac
        shift
    done

    # Behaves depend on local config varibles
    # For $HELP var
    if [ -z $HELP ]; then
        _xhelp
        return $?
    fi
    # For $DEIT var i have no better idea
    if  which $EDIT &> /dev/null; then
      $EDIT=`which $EDIT`  
    fi
    
    # For $FILES
    if [ -n $FILES ]; then
        _xfile $FILES
    fi
    
    # Edit file apply by the number of it
    if [ $? -eq 0]; then
        read -p "Which file you want edit by `basename $EDIT`?\n${FILES}" choice
        if [ -z $choice ]; then
            return 127
        else 
            choice=${FILES:choice}
            _xfile $choice
            unset $choice
        fi
    fi

}

# Create file if necessary and chmod file
function _xfile {
    for i in $@; do
        if [ ! -f $i ]; then
            touch $i
        fi
        [ -e $i ] && chmod u+x $i
    done
    unset i
}

# Help message for the -h agrv and continue
function _xhelp {
    read -p \
        "Which file you want exec command chmod u+x or touch it if not exist?\n`ls`\n:" choice
    if [ -n "$choice" ]; then 
        _xfile $choice
    fi
    unset $choice
}
