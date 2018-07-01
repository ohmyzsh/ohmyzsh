#compdef desk

#
# Completes available desks for `desk`
#
# Requires: desk https://github.com/jamesob/desk
#   Author: Michael Bøcker-Larsen (@mblarsen)
#

_desk() {
    local state ret=1
    local desk_files_location desk_files
    local -a desks

    # In case non-standard location is used
    desk_files_location=${DESK_DESKS_DIR:-~/.desk/desks}
    desk_files=("$desk_files_location"/*.sh)

    # Build list of files without extension
    for file in $desk_files; do
        filename="${file##*/}"
        desks+=${filename%.*}
    done

    _arguments \
      '1:command:->cmds' \
      '2:desk:->desk'

    case $state in
        (cmds)
            _values "desk commands" \
                '.[Activate a desk]' \
                'go[Activate a desk]' \
                'ls[List all desks along with description]' \
                'list[List all desks along with description]' \
                'init[Initialize desk configuration]' \
                'version[Show version information]'
            ret=0
            ;;
        (desk)
            case $words[2] in
                (go|.)
                    _values "available desks" ${desks[@]}
                    ret=0
                    ;;
            esac
            ret=0
            ;;
    esac
    return ret
}

compdef _desk desk