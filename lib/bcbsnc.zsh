function login () {
    mkdir /Volumes/iwserver
    mount -t smbfs //u102084@wcms/iwserver /Volumes/iwserver
}

function livereload() {
    serve $1
}

function serve() {
    serve_path=`pwd`
    if [ -z "$1" ]; then
        serve_path="$1"
        echo "SERVE PATH: $serve_path"
    fi
    echo "=================================================="
    echo "Starting livereload server for $serve_path"
    echo "=================================================="
    echo ""
    lr-http-server -d $serve_path -w **/*.js,**/*.css,**/*.html,**/*.htm,**/*.xml,**/*.svg
}

function wcms() {
    login()
    open -a Firefox http://wcms/iw-cc/command/iw.ui
}

function work() {
    echo "=================================================="
    echo "Starting work in `pwd`"
    echo "=================================================="
    echo ""
    echo "=================================================="
    echo "Open in Sublime"
    echo "=================================================="
    work_dir=`pwd`
    subl $work_dir
    serve $work_dir
}

function get() {
    if [ -z "$1" ]; then
        echo usage: $0 \<git-repo\>
        exit
    else
        cd ~/Source
        git clone $1
    fi
}

export JIRA_URL="https://weboffice.atlassian.net"
export JIRA_NAME="nick.harris"
export JIRA_PREFIX="BC"
# export $JIRA_RAPID_BOARD="false"
# export $JIRA_DEFAULT_ACTION - Action to do when jira is called with no arguments; defaults to "new"
