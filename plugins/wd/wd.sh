#!/bin/zsh

# WARP
# ====
# Jump to custom directories in terminal
# because `cd` takes too long...
#
# @github.com/mfaerevaag/wd


## variables
CONFIG=$HOME/.warprc

## colors
BLUE="\033[96m"
GREEN="\033[92m"
YELLOW="\033[93m"
RED="\033[91m"
NOC="\033[m"


# check if config file exists
if [[ ! -a $CONFIG ]]
then
  # if not: create config file
  touch $CONFIG
fi

## load warp points
typeset -A points
while read line
do
    arr=(${(s,:,)line})
    key=${arr[1]}
    val=${arr[2]}

    points[$key]=$val
done < $CONFIG


## functions
# prepended wd_ to not conflict with your environment (no sub shell)

wd_warp()
{
    if [[ $1 =~ "^\.+$" ]]
    then
        if [[ $#1 < 2 ]]
        then
            wd_print_msg $YELLOW "Warping to current directory?"
        else
            (( n = $#1 - 1 ))
            #wd_print_msg $BLUE "Warping..."
            cd -$n > /dev/null
        fi
    elif [[ ${points[$1]} != "" ]]
    then
        #wd_print_msg $BLUE "Warping..."
        cd ${points[$1]}
    else
        wd_print_msg $RED "Unkown warp point '$1'"
    fi
}

wd_add()
{
    if [[ $2 =~ "^\.+$" || $2 =~ "^\s*$" ]]
    then
        wd_print_msg $RED "Illegal warp point (see README)."
    elif [[ ${points[$2]} == "" ]] || $1
    then
        wd_remove $2 > /dev/null
        print "$2:$PWD" >> $CONFIG
        wd_print_msg $GREEN "Warp point added"
    else
        wd_print_msg $YELLOW "Warp point '$2' already exists. Use 'add!' to overwrite."
    fi
}

wd_remove()
{
    if [[ ${points[$1]} != "" ]]
    then
        if wd_tmp=`sed "/^$1:/d" $CONFIG`
        then
            # `>!` forces overwrite
            # we need this if people use `setopt NO_CLOBBER`
            echo $wd_tmp >! $CONFIG
            wd_print_msg $GREEN "Warp point removed"
        else
            wd_print_msg $RED "Warp point unsuccessfully removed. Sorry!"
        fi
    else
        wd_print_msg $RED "Warp point was not found"
    fi
}

wd_show()
{
    wd_print_msg $BLUE "Warp points to current directory:"
    wd_list_all | grep $PWD$
}

wd_list_all()
{
    wd_print_msg $BLUE "All warp points:"
    while read line
    do
        if [[ $line != "" ]]
        then
            arr=(${(s,:,)line})
            key=${arr[1]}
            val=${arr[2]}

            print "\t" $key "\t -> \t" $val
        fi
    done < $CONFIG
}

wd_print_msg()
{
    if [[ $1 == "" || $2 == "" ]]
    then
        print " $RED*$NOC Could not print message. Sorry!"
    else
        print " $1*$NOC $2"
    fi
}

wd_print_usage()
{
    print "Usage: wd [add|-a|--add] [rm|-r|--remove] [ls|-l|--list] <point>"
    print "\nCommands:"
    print "\t add \t Adds the current working directory to your warp points"
    print "\t add! \t Overwrites existing warp point"
    print "\t rm \t  Removes the given warp point"
    print "\t show \t Outputs warp points to current directory"
    print "\t ls \t Outputs all stored warp points"
    print "\t help \t Show this extremely helpful text"
}


## run

# get opts
args=`getopt -o a:r:lhs -l add:,rm:,ls,help,show -- $*`

# check if no arguments were given
if [[ $? -ne 0 || $#* -eq 0 ]]
then
    wd_print_usage

# check if config file is writeable
elif [[ ! -w $CONFIG ]]
then
    wd_print_msg $RED "\'$CONFIG\' is not writeable."
    # do nothing => exit
    # can't run `exit`, as this would exit the executing shell
    # i.e. your terminal

else
    #set -- $args # WTF

    for i
    do
        case "$i"
            in
            -a|--add|add)
                wd_add false $2
                break
                ;;
            -a!|--add!|add!)
                wd_add true $2
                break
                ;;
            -r|--remove|rm)
                wd_remove $2
                break
                ;;
            -l|--list|ls)
                wd_list_all
                break
                ;;
            -h|--help|help)
                wd_print_usage
                break
                ;;
            -s|--show|show)
                wd_show
                break
                ;;
            *)
                wd_warp $i
                break
                ;;
            --)
                break
                ;;
        esac
    done
fi


## garbage collection
# if not, next time warp will pick up variables from this run
# remember, there's no sub shell
unset points
unset args
unset val &> /dev/null # fixes issue #1
