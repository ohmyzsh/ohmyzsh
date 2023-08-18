#
# If marktext is called without an argument, open MarkText
# If marktext is passed a file, open it in MarkText
#
function marktext() {
    open -a "MarkText.app" "$1"
}
