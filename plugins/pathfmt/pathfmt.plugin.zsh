# provides a function `path_format` that displays the current working directory (on right side)
# in different formats based on the value of the variable PATHFMT_MODE.
#
# Supported formats:
#   - absolute:  full absolute path (default).
#   - user:      Replaces your $HOME with your username (e.g. "ubuntu/dir..").
#   - host:      Displays as "user@hostname:/path", using ~ for home when applicable.
#
# Configure the mode in your ~/.zshrc, e.g.:
#   PATHFMT_MODE="host"
#   plugins=(... pathfmt ...)
#
# and re-load config with source ~/.zshrc


# default=user
: ${PATHFMT_MODE:=user}
function path_user() {
    # user in home? replace with ~/path
    if [[ "$PWD" == "$HOME"* ]]; then
        echo "~${PWD#$HOME}"
    else
        echo "$PWD"
    fi
}



function path_format() {
    case $PATHFMT_MODE in
        absolute)
            #full path from /
            echo "$PWD"
            ;;
        user)
           path_user
           ;;
        host)
            #*check if hostname found (requires:  inetutils' hostname command)
            local host
            if command -v hostname >/dev/null 2>&1; then
                host=$(hostname)
            else
                host="unknown"
            fi
            # path: user@hostname:path, using ~ if in home
            if [[ "$PWD" == "$HOME"* ]]; then
                echo "${USER}@${host}:~${PWD#$HOME}"
            else
                echo "${USER}@${host}:$PWD"
            fi
            ;;
        *)
            #unrecognized: default fallback as user
            path_user
            ;;
    esac
}