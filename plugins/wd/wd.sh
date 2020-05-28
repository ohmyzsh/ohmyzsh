#!/bin/zsh

# WARP DIRECTORY
# ==============
# Jump to custom directories in terminal
# because `cd` takes too long...
#
# @github.com/mfaerevaag/wd

# version
readonly WD_VERSION=0.4.6

# colors
readonly WD_BLUE="\033[96m"
readonly WD_GREEN="\033[92m"
readonly WD_YELLOW="\033[93m"
readonly WD_RED="\033[91m"
readonly WD_NOC="\033[m"

## functions

# helpers
wd_yesorno()
{
    # variables
    local question="${1}"
    local prompt="${question} "
    local yes_RETVAL="0"
    local no_RETVAL="3"
    local RETVAL=""
    local answer=""

    # read-eval loop
    while true ; do
        printf $prompt
        read -r answer

        case ${answer:=${default}} in
            Y|y|YES|yes|Yes )
                RETVAL=${yes_RETVAL} && \
                    break
                ;;
            N|n|NO|no|No )
                RETVAL=${no_RETVAL} && \
                    break
                ;;
            * )
                echo "Please provide a valid answer (y or n)"
                ;;
        esac
    done

    return ${RETVAL}
}

wd_print_msg()
{
    if [[ -z $wd_quiet_mode ]]
    then
        local color=$1
        local msg=$2

        if [[ $color == "" || $msg == "" ]]
        then
            print " ${WD_RED}*${WD_NOC} Could not print message. Sorry!"
        else
            print " ${color}*${WD_NOC} ${msg}"
        fi
    fi
}

wd_print_usage()
{
    cat <<- EOF
Usage: wd [command] [point]

Commands:
    add <point>     Adds the current working directory to your warp points
    add             Adds the current working directory to your warp points with current directory's name
    add! <point>    Overwrites existing warp point
    add!            Overwrites existing warp point with current directory's name
    rm <point>      Removes the given warp point
    rm              Removes the given warp point with current directory's name
    show <point>    Print path to given warp point
    show            Print warp points to current directory
    list            Print all stored warp points
    ls  <point>     Show files from given warp point (ls)
    path <point>    Show the path to given warp point (pwd)
    clean!          Remove points warping to nonexistent directories

    -v | --version  Print version
    -d | --debug    Exit after execution with exit codes (for testing)
    -c | --config   Specify config file (default ~/.warprc)
    -q | --quiet    Suppress all output

    help            Show this extremely helpful text
EOF
}

wd_exit_fail()
{
    local msg=$1

    wd_print_msg $WD_RED $msg
    WD_EXIT_CODE=1
}

wd_exit_warn()
{
    local msg=$1

    wd_print_msg $WD_YELLOW $msg
    WD_EXIT_CODE=1
}

wd_getdir()
{
    local name_arg=$1

    point=$(wd_show $name_arg)
    dir=${point:28+$#name_arg+7}

    if [[ -z $name_arg ]]; then
        wd_exit_fail "You must enter a warp point"
        break
    elif [[ -z $dir ]]; then
        wd_exit_fail "Unknown warp point '${name_arg}'"
        break
    fi
}

# core

wd_warp()
{
    local point=$1
    local sub=$2

    if [[ $point =~ "^\.+$" ]]
    then
        if [[ $#1 < 2 ]]
        then
            wd_exit_warn "Warping to current directory?"
        else
            (( n = $#1 - 1 ))
            cd -$n > /dev/null
        fi
    elif [[ ${points[$point]} != "" ]]
    then
        if [[ $sub != "" ]]
        then
            cd ${points[$point]/#\~/$HOME}/$sub
        else
            cd ${points[$point]/#\~/$HOME}
        fi
    else
        wd_exit_fail "Unknown warp point '${point}'"
    fi
}

wd_add()
{
    local force=$1
    local point=$2

    if [[ $point == "" ]]
    then
        point=$(basename $PWD)
    fi

    if [[ $point =~ "^[\.]+$" ]]
    then
        wd_exit_fail "Warp point cannot be just dots"
    elif [[ $point =~ "[[:space:]]+" ]]
    then
        wd_exit_fail "Warp point should not contain whitespace"
    elif [[ $point == *:* ]]
    then
        wd_exit_fail "Warp point cannot contain colons"
    elif [[ ${points[$point]} == "" ]] || $force
    then
        wd_remove $point > /dev/null
        printf "%q:%s\n" "${point}" "${PWD/#$HOME/~}" >> $WD_CONFIG

        wd_print_msg $WD_GREEN "Warp point added"

        # override exit code in case wd_remove did not remove any points
        # TODO: we should handle this kind of logic better
        WD_EXIT_CODE=0
    else
        wd_exit_warn "Warp point '${point}' already exists. Use 'add!' to overwrite."
    fi
}

wd_remove()
{
    local point=$1

    if [[ $point == "" ]]
    then
        point=$(basename $PWD)
    fi

    if [[ ${points[$point]} != "" ]]
    then
        local config_tmp=$WD_CONFIG.tmp
        if sed -n "/^${point}:.*$/!p" $WD_CONFIG > $config_tmp && mv $config_tmp $WD_CONFIG
        then
            wd_print_msg $WD_GREEN "Warp point removed"
        else
            wd_exit_fail "Something bad happened! Sorry."
        fi
    else
        wd_exit_fail "Warp point was not found"
    fi
}

wd_list_all()
{
    wd_print_msg $WD_BLUE "All warp points:"

    entries=$(sed "s:${HOME}:~:g" $WD_CONFIG)

    max_warp_point_length=0
    while IFS= read -r line
    do
        arr=(${(s,:,)line})
        key=${arr[1]}

        length=${#key}
        if [[ length -gt max_warp_point_length ]]
        then
            max_warp_point_length=$length
        fi
    done <<< $entries

    while IFS= read -r line
    do
        if [[ $line != "" ]]
        then
            arr=(${(s,:,)line})
            key=${arr[1]}
            val=${arr[2]}

            if [[ -z $wd_quiet_mode ]]
            then
                printf "%${max_warp_point_length}s  ->  %s\n" $key $val
            fi
        fi
    done <<< $entries
}

wd_ls()
{
    wd_getdir $1
    ls ${dir/#\~/$HOME}
}

wd_path()
{
    wd_getdir $1
    echo $(echo $dir | sed "s:${HOME}:~:g")
}

wd_show()
{
    local name_arg=$1
    # if there's an argument we look up the value
    if [[ ! -z $name_arg ]]
    then
        if [[ -z $points[$name_arg] ]]
        then
            wd_print_msg $WD_BLUE "No warp point named $name_arg"
        else
            wd_print_msg $WD_GREEN "Warp point: ${WD_GREEN}$name_arg${WD_NOC} -> $points[$name_arg]"
        fi
    else
        # hax to create a local empty array
        local wd_matches
        wd_matches=()
        # do a reverse lookup to check whether PWD is in $points
        PWD="${PWD/$HOME/~}"
        if [[ ${points[(r)$PWD]} == $PWD ]]
        then
            for name in ${(k)points}
            do
                if [[ $points[$name] == $PWD ]]
                then
                    wd_matches[$(($#wd_matches+1))]=$name
                fi
            done

            wd_print_msg $WD_BLUE "$#wd_matches warp point(s) to current directory: ${WD_GREEN}$wd_matches${WD_NOC}"
        else
            wd_print_msg $WD_YELLOW "No warp point to $(echo $PWD | sed "s:$HOME:~:")"
        fi
    fi
}

wd_clean() {
    local force=$1
    local count=0
    local wd_tmp=""

    while read line
    do
        if [[ $line != "" ]]
        then
            arr=(${(s,:,)line})
            key=${arr[1]}
            val=${arr[2]}

            if [ -d "${val/#\~/$HOME}" ]
            then
                wd_tmp=$wd_tmp"\n"`echo $line`
            else
                wd_print_msg $WD_YELLOW "Nonexistent directory: ${key} -> ${val}"
                count=$((count+1))
            fi
        fi
    done < $WD_CONFIG

    if [[ $count -eq 0 ]]
    then
        wd_print_msg $WD_BLUE "No warp points to clean, carry on!"
    else
        if $force || wd_yesorno "Removing ${count} warp points. Continue? (Y/n)"
        then
            echo $wd_tmp >! $WD_CONFIG
            wd_print_msg $WD_GREEN "Cleanup complete. ${count} warp point(s) removed"
        else
            wd_print_msg $WD_BLUE "Cleanup aborted"
        fi
    fi
}

local WD_CONFIG=$HOME/.warprc
local WD_QUIET=0
local WD_EXIT_CODE=0
local WD_DEBUG=0

# Parse 'meta' options first to avoid the need to have them before
# other commands. The `-D` flag consumes recognized options so that
# the actual command parsing won't be affected.

zparseopts -D -E \
    c:=wd_alt_config -config:=wd_alt_config \
    q=wd_quiet_mode -quiet=wd_quiet_mode \
    v=wd_print_version -version=wd_print_version \
    d=wd_debug_mode -debug=wd_debug_mode

if [[ ! -z $wd_print_version ]]
then
    echo "wd version $WD_VERSION"
fi

if [[ ! -z $wd_alt_config ]]
then
    WD_CONFIG=$wd_alt_config[2]
fi

# check if config file exists
if [ ! -e $WD_CONFIG ]
then
    # if not, create config file
    touch $WD_CONFIG
fi

# load warp points
typeset -A points
while read -r line
do
    arr=(${(s,:,)line})
    key=${arr[1]}
    # join the rest, in case the path contains colons
    val=${(j,:,)arr[2,-1]}

    points[$key]=$val
done < $WD_CONFIG

# get opts
args=$(getopt -o a:r:c:lhs -l add:,rm:,clean\!,list,ls:,path:,help,show -- $*)

# check if no arguments were given, and that version is not set
if [[ ($? -ne 0 || $#* -eq 0) && -z $wd_print_version ]]
then
    wd_print_usage

    # check if config file is writeable
elif [ ! -w $WD_CONFIG ]
then
    # do nothing
    # can't run `exit`, as this would exit the executing shell
    wd_exit_fail "\'$WD_CONFIG\' is not writeable."

else

    # parse rest of options
    for o
    do
        case "$o"
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
            -l|list)
                wd_list_all
                break
                ;;
            -ls|ls)
                wd_ls $2
                break
                ;;
            -p|--path|path)
                wd_path $2
                break
                ;;
            -h|--help|help)
                wd_print_usage
                break
                ;;
            -s|--show|show)
                wd_show $2
                break
                ;;
            -c|--clean|clean)
                wd_clean false
                break
                ;;
            -c!|--clean!|clean!)
                wd_clean true
                break
                ;;
            *)
                wd_warp $o $2
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

unset wd_warp
unset wd_add
unset wd_remove
unset wd_show
unset wd_list_all
unset wd_print_msg
unset wd_yesorno
unset wd_print_usage
unset wd_alt_config
unset wd_quiet_mode
unset wd_print_version

unset args
unset points
unset val &> /dev/null # fixes issue #1

if [[ ! -z $wd_debug_mode ]]
then
    exit $WD_EXIT_CODE
else
    unset wd_debug_mode
fi
