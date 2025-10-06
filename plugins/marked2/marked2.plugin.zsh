#
# If marked is called without an argument, open Marked
# If marked is passed a file, open it in Marked
#
function marked() {
    open -a "marked 2.app" "$1"
}
