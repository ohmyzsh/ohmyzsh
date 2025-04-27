#!/usr/bin/env zsh

# WARP DIRECTORY
# ==============
# Jump to custom directories in terminal
# because `cd` takes too long...
#
# @github.com/mfaerevaag/wd

# version
readonly WD_VERSION=0.10.0

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
            "Y"|"y"|"YES"|"yes"|"Yes" )
                RETVAL=${yes_RETVAL} && \
                    break
                ;;
            "N"|"n"|"NO"|"no"|"No" )
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
        local color="${1:-$WD_BLUE}"  # Default to blue if no color is provided
        local msg="$2"

        if [[ -z "$msg" ]]; then
            print "${WD_RED}*${WD_NOC} Could not print message. Sorry!"
        else
            print " ${color}*${WD_NOC} ${msg}"
        fi
    fi
}

wd_print_usage()
{
    command cat <<- EOF
Usage: wd [command] [point]

Commands:
    <point>              Warps to the directory specified by the warp point
    <point> <path>       Warps to the directory specified by the warp point with path appended
    add <point>          Adds the current working directory to your warp points
    add                  Adds the current working directory to your warp points with current directory's name
    addcd <path>         Adds a path to your warp points with the directory's name
    addcd <path> <point> Adds a path to your warp points with a custom name
    rm <point>           Removes the given warp point
    rm                   Removes the given warp point with current directory's name
    show <point>         Print path to given warp point
    show                 Print warp points to current directory
    list                 Print all stored warp points
    ls  <point>          Show files from given warp point (ls)
    open <point>         Open the warp point in the default file explorer (open / xdg-open)
    path <point>         Show the path to given warp point (pwd)
    clean                Remove points warping to nonexistent directories (will prompt unless --force is used)

    -v | --version  Print version
    -c | --config   Specify config file (default ~/.warprc)
    -q | --quiet    Suppress all output
    -f | --force    Allows overwriting without warning (for add & clean)

    help            Show this extremely helpful text
EOF
}

wd_exit_fail()
{
    local msg=$1

    wd_print_msg "$WD_RED" "$msg"
    WD_EXIT_CODE=1
}

wd_exit_warn()
{
    local msg=$1

    wd_print_msg "$WD_YELLOW" "$msg"
    WD_EXIT_CODE=1
}

wd_getdir()
{
    local name_arg=$1

    point=$(wd_show "$name_arg")
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
            WD_EXIT_CODE=$?
        fi
    elif [[ ${points[$point]} != "" ]]
    then
        if [[ $sub != "" ]]
        then
            cd ${points[$point]/#\~/$HOME}/$sub
            WD_EXIT_CODE=$?
        else
            cd ${points[$point]/#\~/$HOME}
            WD_EXIT_CODE=$?
        fi
    else
        wd_exit_fail "Unknown warp point '${point}'"
    fi
}

wd_add()
{
    local point=$1
    local force=$2
    cmdnames=(add rm show list ls path clean help)

    if [[ $point == "" ]]
    then
        point=$(basename "$PWD")
    fi

    if [[ $point =~ "^[\.]+$" ]]
    then
        wd_exit_fail "Warp point cannot be just dots"
    elif [[ $point =~ "[[:space:]]+" ]]
    then
        wd_exit_fail "Warp point should not contain whitespace"
    elif [[ $point =~ : ]] || [[ $point =~ / ]]
    then
        wd_exit_fail "Warp point contains illegal character (:/)"
    elif (($cmdnames[(Ie)$point]))
    then
        wd_exit_fail "Warp point name cannot be a wd command (see wd -h for a full list)"
    elif [[ ${points[$point]} == "" ]] || [ ! -z "$force" ]
    then
        wd_remove "$point" > /dev/null
        printf "%q:%s\n" "${point}" "${PWD/#$HOME/~}" >> "$wd_config_file"
        if (whence sort >/dev/null); then
            local config_tmp=$(mktemp "${TMPDIR:-/tmp}/wd.XXXXXXXXXX")
            # use 'cat' below to ensure we respect $wd_config_file as a symlink
            command sort -o "${config_tmp}" "$wd_config_file" && command cat "${config_tmp}" >| "$wd_config_file" && command rm "${config_tmp}"
        fi

        wd_export_static_named_directories

        wd_print_msg "$WD_GREEN" "Warp point added"

        # override exit code in case wd_remove did not remove any points
        # TODO: we should handle this kind of logic better
        WD_EXIT_CODE=0
    else
        wd_exit_warn "Warp point '${point}' already exists. Use 'add --force' to overwrite."
    fi
}

wd_addcd() {
    local folder="$1"
    local point=$2
    local force=$3
    local currentdir=$PWD

    if [[ -z "$folder" ]]; then
        wd_exit_fail "You must specify a path"
        return
    fi

    if [[ ! -d "$folder" ]]; then
        wd_exit_fail "The directory does not exist"
        return
    fi

    cd "$folder" || return
    wd_add "$point" "$force"
    cd "$currentdir" || return
}


wd_remove()
{
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
            if sed -n "/^${point_name}:.*$/!p" "$wd_config_file" >| "$config_tmp" && command cp "$config_tmp" "$wd_config_file" && command rm "$config_tmp"
            then
                wd_print_msg "$WD_GREEN" "Warp point removed"
            else
                wd_exit_fail "Something bad happened! Sorry."
            fi
        else
            wd_exit_fail "Warp point was not found"
        fi
    done
}

wd_browse() {
    # Check if fzf is installed
    if ! command -v fzf >/dev/null; then
        wd_print_msg "$WD_RED" "This functionality requires fzf. Please install fzf first."
        return 1
    fi

    # Ensure wd_config_file is properly set
    if [[ -z $wd_config_file ]]; then
        wd_config_file="${WD_CONFIG:-$HOME/.warprc}"
    fi

    # Check if config file exists
    if [[ ! -f $wd_config_file ]]; then
        wd_print_msg "$WD_RED" "Config file $wd_config_file does not exist. Please create it first."
        return 1
    fi

    # Read entries from the config file
    local entries=("${(@f)$(sed "s:${HOME}:~:g" "$wd_config_file" | awk -F ':' '{print $1 " -> " $2}')}")
    if [[ -z $entries ]]; then
        wd_print_msg "$WD_YELLOW" "You don't have any warp points to browse"
        return 1
    fi

    # Temp file for remove operations
    local script_path="${${(%):-%x}:h}"
    local wd_remove_output=$(mktemp "${TMPDIR:-/tmp}/wd.XXXXXXXXXX")

    # Create fzf bindings
    entries=("All warp points:" "Press enter to select. Press delete to remove" "${entries[@]}")
    local fzf_bind="delete:execute(echo {} | awk -F ' -> ' '{print \$1}' | xargs -I {} \"$script_path/wd.sh\" rm {} > \"$wd_remove_output\")+abort"

    # Run fzf
    local selected_entry=$(printf '%s\n' "${entries[@]}" | fzf --height 100% --reverse --header-lines=2 --bind="$fzf_bind")

    # Handle selection
    if [[ -e $wd_remove_output ]]; then
        cat "$wd_remove_output"
        rm -f "$wd_remove_output"
    fi

    if [[ -n $selected_entry ]]; then
        local selected_point="${selected_entry%% ->*}"
        selected_point=$(echo "$selected_point" | xargs)
        wd $selected_point
    fi
}

wd_browse_widget() {
    # Ensure wd_config_file is properly set
    if [[ -z $wd_config_file ]]; then
        wd_config_file="${WD_CONFIG:-$HOME/.warprc}"
    fi

    # Check if config file exists
    if [[ ! -f $wd_config_file ]]; then
        wd_print_msg "$WD_RED" "Config file $wd_config_file does not exist. Please create it first."
        return 1
    fi

    # Call wd_browse to handle the selection
    wd_browse

    # Restore the zsh buffer and cursor after running wd_browse
    saved_buffer=$BUFFER
    saved_cursor=$CURSOR
    BUFFER=
    zle redisplay
    zle accept-line
}

wd_restore_buffer() {
  if [[ -n $saved_buffer ]]; then
    BUFFER=$saved_buffer
    CURSOR=$saved_cursor
  fi
  saved_buffer=
  saved_cursor=1
}

wd_list_all()
{
    wd_print_msg "$WD_BLUE" "All warp points:"

    entries=$(sed "s:${HOME}:~:g" "$wd_config_file")

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

    while IFS= read -r line
    do
        if [[ $line != "" ]]
        then
            arr=(${(s,:,)line})
            key=${arr[1]}
            val=${line#"${arr[1]}:"}

            if [[ -z $wd_quiet_mode ]]
            then
                printf "%${max_warp_point_length}s  ->  %s\n" "$key" "$val"
            fi
        fi
    done <<< "$entries"
}

wd_ls()
{
    wd_getdir "$1"
    ls "${dir/#\~/$HOME}"
}

wd_open()
{
    wd_getdir "$1"
    if command -v open >/dev/null 2>&1; then
        # MacOS, Ubuntu (alias)
        open "${dir/#\~/$HOME}"
    elif command -v xdg-open >/dev/null 2>&1; then
        # Most Linux desktops
        xdg-open "${dir/#\~/$HOME}"
    else
        echo "No known file opener found (need 'open' or 'xdg-open')." >&2
        exit 1
    fi
}

wd_path()
{
    wd_getdir "$1"
    echo "$(echo "$dir" | sed "s:~:${HOME}:g")"
}

wd_show()
{
    local name_arg=$1
    local show_pwd
    # if there's an argument we look up the value
    if [[ -n $name_arg ]]
    then
        if [[ -z $points[$name_arg] ]]
        then
            wd_print_msg "$WD_BLUE" "No warp point named $name_arg"
        else
            wd_print_msg "$WD_GREEN" "Warp point: ${WD_GREEN}$name_arg${WD_NOC} -> $points[$name_arg]"
        fi
    else
        # hax to create a local empty array
        local wd_matches
        wd_matches=()
        # do a reverse lookup to check whether PWD is in $points
        show_pwd="${PWD/$HOME/~}"
        if [[ ${points[(r)$show_pwd]} == "$show_pwd" ]]
        then
            for name in ${(k)points}
            do
                if [[ $points[$name] == "$show_pwd" ]]
                then
                    wd_matches[$(($#wd_matches+1))]=$name
                fi
            done

            wd_print_msg "$WD_BLUE" "$#wd_matches warp point(s) to current directory: ${WD_GREEN}$wd_matches${WD_NOC}"
        else
            wd_print_msg "$WD_YELLOW" "No warp point to $show_pwd"
        fi
    fi
}

wd_clean() {
    local force=$1
    local count=0
    local wd_tmp=""

    while read -r line
    do
        if [[ $line != "" ]]
        then
            arr=(${(s,:,)line})
            key=${arr[1]}
            val=${arr[2]}

            if [ -d "${val/#\~/$HOME}" ]
            then
                wd_tmp=$wd_tmp"\n"`echo "$line"`
            else
                wd_print_msg "$WD_YELLOW" "Nonexistent directory: ${key} -> ${val}"
                count=$((count+1))
            fi
        fi
    done < "$wd_config_file"

    if [[ $count -eq 0 ]]
    then
        wd_print_msg "$WD_BLUE" "No warp points to clean, carry on!"
    else
        if [ ! -z "$force" ] || wd_yesorno "Removing ${count} warp points. Continue? (y/n)"
        then
            echo "$wd_tmp" >! "$wd_config_file"
            wd_print_msg "$WD_GREEN" "Cleanup complete. ${count} warp point(s) removed"
        else
            wd_print_msg "$WD_BLUE" "Cleanup aborted"
        fi
    fi
}

wd_export_static_named_directories() {
  if [[ ! -z $WD_EXPORT ]]
  then
    command grep '^[0-9a-zA-Z_-]\+:' "$wd_config_file" | sed -e "s,~,$HOME," -e 's/:/=/' | while read -r warpdir ; do
        hash -d "$warpdir"
    done
  fi
}

WD_CONFIG=${WD_CONFIG:-$HOME/.warprc}
local WD_QUIET=0
local WD_EXIT_CODE=0

# Parse 'meta' options first to avoid the need to have them before
# other commands. The `-D` flag consumes recognized options so that
# the actual command parsing won't be affected.

zparseopts -D -E \
    c:=wd_alt_config -config:=wd_alt_config \
    q=wd_quiet_mode -quiet=wd_quiet_mode \
    v=wd_print_version -version=wd_print_version \
    f=wd_force_mode -force=wd_force_mode

if [[ ! -z $wd_print_version ]]
then
    echo "wd version $WD_VERSION"
fi

# set the config file from variable or default
typeset wd_config_file=${WD_CONFIG:-$HOME/.warprc}
if [[ ! -z $wd_alt_config ]]
then
    # prefer the flag if provided
    wd_config_file=$wd_alt_config[2]
fi

# check if config file exists
if [ ! -e "$wd_config_file" ]
then
    # if not, create config file
    touch "$wd_config_file"
else
    wd_export_static_named_directories
fi

# disable extendedglob for the complete wd execution time
setopt | grep -q extendedglob
wd_extglob_is_set=$?
if (( wd_extglob_is_set == 0 )); then
    setopt noextendedglob
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
done < "$wd_config_file"

# get opts
args=$(getopt -o a:r:c:lhs -l add:,rm:,clean,list,ls:,open:,path:,help,show -- $*)

# check if no arguments were given, and that version is not set
if [[ ($? -ne 0 || $#* -eq 0) && -z $wd_print_version ]]
then
    wd_print_usage

# check if config file is writeable
elif [ ! -w "$wd_config_file" ]
then
    # do nothing
    # can't run `exit`, as this would exit the executing shell
    wd_exit_fail "\'$wd_config_file\' is not writeable."

else
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
            "-b"|"browse")
                wd_browse
                break
                ;;
            "-c"|"--addcd"|"addcd")
                wd_addcd "$2" "$3" "$wd_force_mode"
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
            "-o"|"--open"|"open")
                wd_open "$2"
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

if (( wd_extglob_is_set == 0 )); then
    setopt extendedglob
fi

unset wd_extglob_is_set
unset wd_warp
unset wd_add
unset wd_addcd
unset wd_remove
unset wd_show
unset wd_list_all
unset wd_print_msg
unset wd_yesorno
unset wd_print_usage
unset wd_alt_config
#unset wd_config_file do not unset this - breaks keybind
unset wd_quiet_mode
unset wd_print_version
unset wd_force_mode
unset wd_export_static_named_directories
unset wd_o

unset args
unset points
unset val &> /dev/null # fixes issue #1

return $WD_EXIT_CODE
