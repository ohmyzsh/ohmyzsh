# Serves html documentation from /usr/share/doc and opens it in your browser
# Args:
#   doc_folder: folder in /usr/share/doc that should be served
function serve-doc() {
    local doc_base_path="/usr/share/doc"
    local doc_folder=$1
    local old_folder=$(pwd)

    local folder="$doc_base_path/$doc_folder"
    cd $folder || return
    # look for an index file
    if [ -e "$folder/index.html" ]; then
        serve-html $folder
    else
        # look if there is one in /html
        [ -e "$folder/html/index.html" ] \
            && {cd $old_folder; serve-html "$folder/html"} \
            || {echo "No documentation for that."; cd $old_folder >/dev/null}
    fi
}

# Serves html from a folder and opens it in your browser
# Args:
#   folder: folder that should be served
function serve-html() {
    which python >/dev/null
    if [ $? -ne 0 ]; then
        echo "This function (serve-doc) uses Python. Please install it."
        return
    fi
    local folder=$1
    local old_folder=$(pwd)
    cd $folder || return

    # python2 prints --version to stderr, python3 to stdout
    if [[ $(python --version 2>&1) =~ "Python 2.*" ]]; then
        local invocation="python -m SimpleHTTPServer"
    else
        local invocation="python -m http.server"
    fi

    # This is not really equally distributed, but who cares
    local port=$RANDOM
    let "port %= 10000"
    let "port += 50000"

    # start server, put it in background
    eval "$invocation $port >/dev/null" &
    # open docs in browser
    xdg-open "http://localhost:$port" &
    cd $old_folder
    # put server into foreground
    fg; fg
}
