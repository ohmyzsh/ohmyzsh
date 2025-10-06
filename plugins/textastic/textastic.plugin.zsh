#
# If the tt command is called without an argument, launch Textastic
# If tt is passed a directory, cd to it and open it in Textastic
# If tt is passed a file, open it in Textastic
#
function tt() {
    if [[ -z "$1" ]]
    then
        open -a "textastic.app"
    else
        open -a "textastic.app" "$1"
        if [[ -d "$1" ]]
        then
            cd "$1"
        fi
    fi
}
