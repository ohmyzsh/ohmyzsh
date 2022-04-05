#!/bin/zsh

# WARP DIRECTORY
# ==============
# Jump to custom directories in terminal
# because `cd` takes too long...
#
# @github.com/mfaerevaag/wd

# version
<<<<<<< HEAD
readonly WD_VERSION=0.4
=======
readonly WD_VERSION=0.5.0
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

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
<<<<<<< HEAD
            Y|y|YES|yes|Yes )
                RETVAL=${yes_RETVAL} && \
                    break
                ;;
            N|n|NO|no|No )
=======
            "Y"|"y"|"YES"|"yes"|"Yes" )
                RETVAL=${yes_RETVAL} && \
                    break
                ;;
            "N"|"n"|"NO"|"no"|"No" )
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
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
<<<<<<< HEAD
    cat <<- EOF
Usage: wd [command] <point>

Commands:
	add <point>	Adds the current working directory to your warp points
	add! <point>	Overwrites existing warp point
	rm <point>	Removes the given warp point
	show		Print warp points to current directory
	show <point>	Print path to given warp point
	list	        Print all stored warp points
ls  <point>     Show files from given warp point
path <point>    Show the path to given warp point
	clean!		Remove points warping to nonexistent directories

	-v | --version	Print version
	-d | --debug	Exit after execution with exit codes (for testing)
	-c | --config	Specify config file (default ~/.warprc)
	-q | --quiet	Suppress all output

	help		Show this extremely helpful text
=======
    command cat <<- EOF
Usage: wd [command] [point]

Commands:
    <point>         Warps to the directory specified by the warp point
    <point> <path>  Warps to the directory specified by the warp point with path appended
    add <point>     Adds the current working directory to your warp points
    add             Adds the current working directory to your warp points with current directory's name
    rm <point>      Removes the given warp point
    rm              Removes the given warp point with current directory's name
    show <point>    Print path to given warp point
    show            Print warp points to current directory
    list            Print all stored warp points
    ls  <point>     Show files from given warp point (ls)
    path <point>    Show the path to given warp point (pwd)
    clean           Remove points warping to nonexistent directories (will prompt unless --force is used)

    -v | --version  Print version
    -d | --debug    Exit after execution with exit codes (for testing)
    -c | --config   Specify config file (default ~/.warprc)
    -q | --quiet    Suppress all output
    -f | --force    Allows overwriting without warning (for add & clean)

    help            Show this extremely helpful text
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
EOF
}

wd_exit_fail()
{
    local msg=$1

<<<<<<< HEAD
    wd_print_msg $WD_RED $msg
=======
    wd_print_msg "$WD_RED" "$msg"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    WD_EXIT_CODE=1
}

wd_exit_warn()
{
    local msg=$1

<<<<<<< HEAD
    wd_print_msg $WD_YELLOW $msg
=======
    wd_print_msg "$WD_YELLOW" "$msg"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    WD_EXIT_CODE=1
}

wd_getdir()
{
    local name_arg=$1

<<<<<<< HEAD
    point=$(wd_show $name_arg)
=======
    point=$(wd_show "$name_arg")
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
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
<<<<<<< HEAD

    if [[ $point =~ "^\.+$" ]]
    then
        if [ $#1 < 2 ]
=======
    local sub=$2

    if [[ $point =~ "^\.+$" ]]
    then
        if [[ $#1 < 2 ]]
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
        then
            wd_exit_warn "Warping to current directory?"
        else
            (( n = $#1 - 1 ))
            cd -$n > /dev/null
        fi
    elif [[ ${points[$point]} != "" ]]
    then
<<<<<<< HEAD
        cd ${points[$point]}
=======
        if [[ $sub != "" ]]
        then
            cd ${points[$point]/#\~/$HOME}/$sub
        else
            cd ${points[$point]/#\~/$HOME}
        fi
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    else
        wd_exit_fail "Unknown warp point '${point}'"
    fi
}

wd_add()
{
<<<<<<< HEAD
    local force=$1
    local point=$2
=======
    local point=$1
    local force=$2

    if [[ $point == "" ]]
    then
        point=$(basename "$PWD")
    fi
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

    if [[ $point =~ "^[\.]+$" ]]
    then
        wd_exit_fail "Warp point cannot be just dots"
    elif [[ $point =~ "[[:space:]]+" ]]
    then
        wd_exit_fail "Warp point should not contain whitespace"
<<<<<<< HEAD
    elif [[ $point == *:* ]]
    then
        wd_exit_fail "Warp point cannot contain colons"
    elif [[ $point == "" ]]
    then
        wd_exit_fail "Warp point cannot be empty"
    elif [[ ${points[$2]} == "" ]] || $force
    then
        wd_remove $point > /dev/null
        printf "%q:%s\n" "${point}" "${PWD}" >> $WD_CONFIG

        wd_print_msg $WD_GREEN "Warp point added"
=======
    elif [[ $point =~ : ]] || [[ $point =~ / ]]
    then
        wd_exit_fail "Warp point contains illegal character (:/)"
    elif [[ ${points[$point]} == "" ]] || [ ! -z "$force" ]
    then
        wd_remove "$point" > /dev/null
        printf "%q:%s\n" "${point}" "${PWD/#$HOME/~}" >> "$WD_CONFIG"
        if (whence sort >/dev/null); then
            local config_tmp=$(mktemp "${TMPDIR:-/tmp}/wd.XXXXXXXXXX")
            # use 'cat' below to ensure we respect $WD_CONFIG as a symlink
            command sort -o "${config_tmp}" "$WD_CONFIG" && command cat "${config_tmp}" > "$WD_CONFIG" && command rm "${config_tmp}"
        fi

        wd_export_static_named_directories

        wd_print_msg "$WD_GREEN" "Warp point added"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

        # override exit code in case wd_remove did not remove any points
        # TODO: we should handle this kind of logic better
        WD_EXIT_CODE=0
    else
<<<<<<< HEAD
        wd_exit_warn "Warp point '${point}' already exists. Use 'add!' to overwrite."
=======
        wd_exit_warn "Warp point '${point}' already exists. Use 'add --force' to overwrite."
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    fi
}

wd_remove()
{
<<<<<<< HEAD
    local point=$1

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
=======
    local point_list=$1

    if [[ "$point_list" == "" ]]
    then
        point_list=$(basename "$PWD")
    fi

    for point_name in $point_list ; do
        if [[ ${points[$point_name]} != "" ]]
        then
            local config_tmp=$(mktemp "${TMPDIR:-/tmp}/wd.XXXXXXXXXX")
            # Copy and delete in two steps in order to preserve symlinks
            if sed -n "/^${point_name}:.*$/!p" "$WD_CONFIG" > "$config_tmp" && command cp "$config_tmp" "$WD_CONFIG" && command rm "$config_tmp"
            then
                wd_print_msg "$WD_GREEN" "Warp point removed"
            else
                wd_exit_fail "Something bad happened! Sorry."
            fi
        else
            wd_exit_fail "Warp point was not found"
        fi
    done
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

wd_list_all()
{
<<<<<<< HEAD
    wd_print_msg $WD_BLUE "All warp points:"
=======
    wd_print_msg "$WD_BLUE" "All warp points:"

    entries=$(sed "s:${HOME}:~:g" "$WD_CONFIG")

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
    done <<< "$entries"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

    while IFS= read -r line
    do
        if [[ $line != "" ]]
        then
            arr=(${(s,:,)line})
            key=${arr[1]}
            val=${arr[2]}

            if [[ -z $wd_quiet_mode ]]
            then
<<<<<<< HEAD
                printf "%20s  ->  %s\n" $key $val
            fi
        fi
    done <<< $(sed "s:${HOME}:~:g" $WD_CONFIG)
=======
                printf "%${max_warp_point_length}s  ->  %s\n" "$key" "$val"
            fi
        fi
    done <<< "$entries"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

wd_ls()
{
<<<<<<< HEAD
    wd_getdir $1
    ls $dir
=======
    wd_getdir "$1"
    ls "${dir/#\~/$HOME}"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

wd_path()
{
<<<<<<< HEAD
    wd_getdir $1
    echo $(echo $dir | sed "s:${HOME}:~:g")
=======
    wd_getdir "$1"
    echo "$(echo "$dir" | sed "s:~:${HOME}:g")"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

wd_show()
{
    local name_arg=$1
    # if there's an argument we look up the value
<<<<<<< HEAD
    if [[ ! -z $name_arg ]]
    then
        if [[ -z $points[$name_arg] ]]
        then
            wd_print_msg $WD_BLUE "No warp point named $name_arg"
        else
            wd_print_msg $WD_GREEN "Warp point: ${WD_GREEN}$name_arg${WD_NOC} -> $points[$name_arg]"
=======
    if [[ -n $name_arg ]]
    then
        if [[ -z $points[$name_arg] ]]
        then
            wd_print_msg "$WD_BLUE" "No warp point named $name_arg"
        else
            wd_print_msg "$WD_GREEN" "Warp point: ${WD_GREEN}$name_arg${WD_NOC} -> $points[$name_arg]"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
        fi
    else
        # hax to create a local empty array
        local wd_matches
        wd_matches=()
        # do a reverse lookup to check whether PWD is in $points
<<<<<<< HEAD
        if [[ ${points[(r)$PWD]} == $PWD ]]
        then
            for name in ${(k)points}
            do
                if [[ $points[$name] == $PWD ]]
=======
        PWD="${PWD/$HOME/~}"
        if [[ ${points[(r)$PWD]} == "$PWD" ]]
        then
            for name in ${(k)points}
            do
                if [[ $points[$name] == "$PWD" ]]
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
                then
                    wd_matches[$(($#wd_matches+1))]=$name
                fi
            done

<<<<<<< HEAD
            wd_print_msg $WD_BLUE "$#wd_matches warp point(s) to current directory: ${WD_GREEN}$wd_matches${WD_NOC}"
        else
            wd_print_msg $WD_YELLOW "No warp point to $(echo $PWD | sed "s:$HOME:~:")"
=======
            wd_print_msg "$WD_BLUE" "$#wd_matches warp point(s) to current directory: ${WD_GREEN}$wd_matches${WD_NOC}"
        else
            wd_print_msg "$WD_YELLOW" "No warp point to $(echo "$PWD" | sed "s:$HOME:~:")"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
        fi
    fi
}

wd_clean() {
    local force=$1
    local count=0
    local wd_tmp=""

<<<<<<< HEAD
    while read line
=======
    while read -r line
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    do
        if [[ $line != "" ]]
        then
            arr=(${(s,:,)line})
            key=${arr[1]}
            val=${arr[2]}

<<<<<<< HEAD
            if [ -d "$val" ]
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
=======
            if [ -d "${val/#\~/$HOME}" ]
            then
                wd_tmp=$wd_tmp"\n"`echo "$line"`
            else
                wd_print_msg "$WD_YELLOW" "Nonexistent directory: ${key} -> ${val}"
                count=$((count+1))
            fi
        fi
    done < "$WD_CONFIG"

    if [[ $count -eq 0 ]]
    then
        wd_print_msg "$WD_BLUE" "No warp points to clean, carry on!"
    else
        if [ ! -z "$force" ] || wd_yesorno "Removing ${count} warp points. Continue? (y/n)"
        then
            echo "$wd_tmp" >! "$WD_CONFIG"
            wd_print_msg "$WD_GREEN" "Cleanup complete. ${count} warp point(s) removed"
        else
            wd_print_msg "$WD_BLUE" "Cleanup aborted"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
        fi
    fi
}

<<<<<<< HEAD
local WD_CONFIG=$HOME/.warprc
=======
wd_export_static_named_directories() {
  if [[ ! -z $WD_EXPORT ]]
  then
    command grep '^[0-9a-zA-Z_-]\+:' "$WD_CONFIG" | sed -e "s,~,$HOME," -e 's/:/=/' | while read -r warpdir ; do
        hash -d "$warpdir"
    done
  fi
}

local WD_CONFIG=${WD_CONFIG:-$HOME/.warprc}
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
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
<<<<<<< HEAD
    d=wd_debug_mode -debug=wd_debug_mode
=======
    d=wd_debug_mode -debug=wd_debug_mode \
    f=wd_force_mode -force=wd_force_mode
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

if [[ ! -z $wd_print_version ]]
then
    echo "wd version $WD_VERSION"
fi

if [[ ! -z $wd_alt_config ]]
then
    WD_CONFIG=$wd_alt_config[2]
fi

# check if config file exists
<<<<<<< HEAD
if [ ! -e $WD_CONFIG ]
then
    # if not, create config file
    touch $WD_CONFIG
=======
if [ ! -e "$WD_CONFIG" ]
then
    # if not, create config file
    touch "$WD_CONFIG"
else
    wd_export_static_named_directories
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
fi

# load warp points
typeset -A points
while read -r line
do
    arr=(${(s,:,)line})
    key=${arr[1]}
<<<<<<< HEAD
    val=${arr[2]}

    points[$key]=$val
done < $WD_CONFIG

# get opts
args=$(getopt -o a:r:c:lhs -l add:,rm:,clean\!,list,ls:,path:,help,show -- $*)
=======
    # join the rest, in case the path contains colons
    val=${(j,:,)arr[2,-1]}

    points[$key]=$val
done < "$WD_CONFIG"

# get opts
args=$(getopt -o a:r:c:lhs -l add:,rm:,clean,list,ls:,path:,help,show -- $*)
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

# check if no arguments were given, and that version is not set
if [[ ($? -ne 0 || $#* -eq 0) && -z $wd_print_version ]]
then
    wd_print_usage

<<<<<<< HEAD
    # check if config file is writeable
elif [ ! -w $WD_CONFIG ]
=======
# check if config file is writeable
elif [ ! -w "$WD_CONFIG" ]
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
then
    # do nothing
    # can't run `exit`, as this would exit the executing shell
    wd_exit_fail "\'$WD_CONFIG\' is not writeable."

else
<<<<<<< HEAD

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
                wd_warp $o
=======
    # parse rest of options
    local wd_o
    for wd_o
    do
        case "$wd_o"
            in
            "-a"|"--add"|"add")
                wd_add "$2" "$wd_force_mode"
                break
                ;;
            "-e"|"export")
                wd_export_static_named_directories
                break
                ;;
            "-r"|"--remove"|"rm")
                # Passes all the arguments as a single string separated by whitespace to wd_remove
                wd_remove "${@:2}"
                break
                ;;
            "-l"|"list")
                wd_list_all
                break
                ;;
            "-ls"|"ls")
                wd_ls "$2"
                break
                ;;
            "-p"|"--path"|"path")
                wd_path "$2"
                break
                ;;
            "-h"|"--help"|"help")
                wd_print_usage
                break
                ;;
            "-s"|"--show"|"show")
                wd_show "$2"
                break
                ;;
            "-c"|"--clean"|"clean")
                wd_clean "$wd_force_mode"
                break
                ;;
            *)
                wd_warp "$wd_o" "$2"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
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
<<<<<<< HEAD
=======
unset wd_export_static_named_directories
unset wd_o
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

unset args
unset points
unset val &> /dev/null # fixes issue #1

<<<<<<< HEAD
if [[ ! -z $wd_debug_mode ]]
=======
if [[ -n $wd_debug_mode ]]
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
then
    exit $WD_EXIT_CODE
else
    unset wd_debug_mode
fi
