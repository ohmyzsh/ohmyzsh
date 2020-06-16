###########################
# Settings

# These can be overwritten any time.
# If they are not set yet, they will be
# overwritten with their default values

default fastfile_dir        "${HOME}/.fastfile"
default fastfile_var_prefix "§"

###########################
# Impl

#
# Generate a shortcut
#
# Arguments:
#    1. name - The name of the shortcut (default: name of the file)
#    2. file - The file or directory to make the shortcut for
# STDOUT:
#    => fastfle_print
#
function fastfile() {
    test "$2" || 2="."
    file=$(readlink -f "$2")

    test "$1" || 1="$(basename "$file")"
    name=$(echo "$1" | tr " " "_")


    mkdir -p "${fastfile_dir}"
    echo "$file" > "$(fastfile_resolv "$name")"

    fastfile_sync
    fastfile_print "$name"
}

#
# Resolve the location of a shortcut file (the database file, where the value is written!)
#
# Arguments:
#    1. name - The name of the shortcut
# STDOUT:
#   The path to the shortcut file
#
function fastfile_resolv() {
    echo "${fastfile_dir}${1}"
}

#
# Get the real path of a shortcut
#
# Arguments:
#    1. name - The name of the shortcut
# STDOUT:
#    The path
#
function fastfile_get() {
    cat "$(fastfile_resolv "$1")"
}

#
# Print a shortcut
#
# Arguments:
#    1. name - The name of the shortcut
# STDOUT:
#    Name and value of the shortcut
#
function fastfile_print() {
    echo "${fastfile_var_prefix}${1} -> $(fastfile_get "$1")"
}

#
# List all shortcuts
#
# STDOUT:
#    (=> fastfle_print) for each shortcut
#
function fastfile_ls() {
    for f in "${fastfile_dir}"/*(NF); do
        file=`basename "$f"` # To enable simpler handeling of spaces in file names
        varkey=`echo "$file" | tr " " "_"`

        # Special format for colums
        echo "${fastfile_var_prefix}${varkey}|->|$(fastfile_get "$file")"
    done | column -t -s "|"
}

#
# Remove a shortcut
#
# Arguments:
#    1. name - The name of the shortcut (default: name of the file)
# STDOUT:
#    => fastfle_print
#
function fastfile_rm() {
    fastfile_print "$1"
    rm "$(fastfile_resolv "$1")"
}

#
# Generate the aliases for the shortcuts
#
function fastfile_sync() {
    for f in "${fastfile_dir}"/*(NF); do
        file=`basename "$f"` # To enable simpler handeling of spaces in file names
        varkey=`echo "$file" | tr " " "_"`

        alias -g "${fastfile_var_prefix}${varkey}"="'$(fastfile_get "$file")'"
    done
}

##################################
# Shortcuts

alias ff=fastfile
alias ffp=fastfile_print
alias ffrm=fastfile_rm
alias ffls=fastfile_ls
alias ffsync=fastfile_sync

##################################
# Init

fastfile_sync
