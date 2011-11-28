if [[ -x /usr/bin/pkgfile ]]; then
  command_not_found_handler() {
    local pkg p
    local pid ppid pgrp session tty_nr tpgid

    # double check pkgfile exists
    [[ ! -x /usr/bin/pkgfile ]] && return 127

    # do not run when within a pipe or subshell
    [[ ! -t 1  ]] && return 127
    read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
    [[ $$ -eq $tpgid ]] && return 127

    saveIFS=$IFS; IFS=$'\n';
    pkg=($(pkgfile -b -v -- $1))
    IFS=$saveIFS

    if [[ -z $pkg ]] && return 127

    echo "The command \"$1\" can be found in the following packages:"
    for p in $pkg; echo "    $p"
  }
fi
