#!zsh

# This script arranges some percol-related userful zle-widgets and
# commands
#
# To use this script, put a following line into your .zshrc
#
#   source PATH_TO_THIS_FILE
#
# Then, you can bind percol's zle-widgets to some key, by calling
# bindkey.
#
#   bindkey '^R' percol_select_history
#
# Here is the list of zle-widgets provided by this script.
#
#  * percol_select_history
#  * percol_cd_sibling
#  * percol_cd_upper_dirs
#  * percol_cd_bookmark
#  * percol_cd_repository
#  * percol_insert_bookmark
#  * percol_insert_ls
#
# And this script also provides following commands.
#
#  * ppgrep
#  * ppkill
#
# Enjoy!

# ------------------------------------------------------------ #
# Initialize
# ------------------------------------------------------------ #

PERCOL_ENABLED=true

function exists() {
  which $1 &> /dev/null
}

# Define tac wrapper
exists gtac && _PERCOL_TAC="gtac" || \
    { exists tac && _PERCOL_TAC="tac" || \
    { _PERCOL_TAC="tail -r" } }
function _percol_tac() {
    eval $_PERCOL_TAC
}

# Arrange a tmp dir for percol
PERCOL_TMP_DIR=/tmp/percol.zsh.tmp
if ! [ -d ${PERCOL_TMP_DIR} ]; then
    mkdir ${PERCOL_TMP_DIR}
fi

# ------------------------------------------------------------ #
# FIFO for percol_popup
# ------------------------------------------------------------ #

# Arrange fifos
local PERCOL_IN=${PERCOL_TMP_DIR}/percol-channel-in-$$
local PERCOL_OUT=${PERCOL_TMP_DIR}/percol-channel-out-$$
function _percol_create_fifo() {
    [ -p $PERCOL_IN ] || { command rm -f $PERCOL_IN; mkfifo -m 600 $PERCOL_IN }
    [ -p $PERCOL_OUT ] || { command rm -f $PERCOL_OUT; mkfifo -m 600 $PERCOL_OUT }
}
function _percol_clean_fifos() {
    command rm -f $PERCOL_IN
    command rm -f $PERCOL_OUT
}
trap _percol_clean_fifos EXIT SIGINT SIGTERM

# ------------------------------------------------------------ #
# Arrange percol_popup on top of tmux
# ------------------------------------------------------------ #

function _percol_popup_tmux() {
    _percol_create_fifo
    tmux split-window "percol $* < ${PERCOL_IN} > ${PERCOL_OUT}"
}

function _percol_popup() {
    INPUT=$1
    PERCOL_OPTION=$2
    if [[ -n $TMUX && -n $PERCOL_USE_TMUX ]]; then
        eval "_percol_popup_tmux ${PERCOL_OPTION}; ${INPUT} > ${PERCOL_IN} &; cat ${PERCOL_OUT}"
    else
        eval "${INPUT} | percol ${(Q)PERCOL_OPTION}"
    fi
}

# ------------------------------------------------------------ #
# Common functions
# ------------------------------------------------------------ #

# TODO: I'm not sure whether this process is proper or not
function _percol_clean_prompt() {
    if [[ -n $TMUX ]]; then
        zle reset-prompt
    else
        zle -R -c
    fi
}

function _percol_list_upper_directories() {
    local dir_cursor
    dir_cursor=$(dirname ${PWD})
    local dir_prefix="../../"
    while [[ ${dir_cursor} != "/" ]]; do
        echo ${dir_prefix}$(basename ${dir_cursor})
        dir_cursor=$(dirname ${dir_cursor})
        dir_prefix="../"${dir_prefix}
    done
    echo "/"
}

function _percol_list_siblings() {
    local mydirname=$(basename $PWD)
    local parentdir=$(dirname $PWD)
    find $parentdir -maxdepth 1 -type d ! -iname ".*" -printf "%f\n" | sed -n '/${mydirname}/!p'
}

function _percol_get_destination_from_history() {
    _percol_popup 'sort ${CD_HISTORY_FILE} | uniq -c | sort -r | \
        sed -e "s/^[ ]*[0-9]*[ ]*//" | \
        sed -e s"/^${HOME//\//\\/}/~/"'
}

function _percol_go_to_repository_top() {
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}

function _percol_get_repository_dir() {
    _percol_go_to_repository_top > /dev/null;
    destination=$(_percol_popup 'find . -path "*/.git" -prune -o -type d')
    if [[ $destination != "" ]]; then
        r > /dev/null
        cd $destination > /dev/null
        echo $PWD
    else
        echo ""
    fi
}

# ------------------------------------------------------------ #
# Define percol widgets
# ------------------------------------------------------------ #

function percol_select_history() {
    output=$(_percol_popup 'history -n 1 | _percol_tac' '--query \"${LBUFFER}\"')

    if [[ $output != "" ]]; then
        BUFFER=$output
        CURSOR=$#BUFFER
    fi

    _percol_clean_prompt
}
zle -N percol_select_history

function percol_cd_sibling() {
    destination=$(_percol_popup "_percol_list_siblings")
    if [[ $destination != "" ]]; then
        cd $destination
    fi
    _percol_clean_prompt
}
zle -N percol_cd_sibling

function percol_cd_upper_dirs() {
    destination=$(_percol_popup "_percol_list_upper_directories")
    if [[ $destination != "" ]]; then
        cd $destination
    fi
    _percol_clean_prompt
}
zle -N percol_cd_upper_dirs

function percol_insert_bookmark() {
    local destination=$(_percol_get_destination_from_history)
    if [ $? -eq 0 ]; then
        local new_left="${LBUFFER} ${destination} "
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
    _percol_clean_prompt
}
zle -N percol_insert_bookmark

function percol_cd_bookmark() {
    local destination=$(_percol_get_destination_from_history)
    [ -n $destination ] && cd ${destination/#\~/${HOME}}
    _percol_clean_prompt
}
zle -N percol_cd_bookmark

function percol_insert_ls() {
    local basedir
    local left
    basedir=$(echo ${LBUFFER} | perl -e '<STDIN> =~ /((?:[^ ]|\\\\ )+)$/; print "$1";')
    left=$(echo ${LBUFFER} | perl -e '<STDIN> =~ /(.*)((?:[^ ]|\\\\ )+)$/; print "$1";')

    local destination
    if [ -n $basedir ]; then
        destination=$(\ls $basedir | percol)
    else
        destination=$(\ls | percol)
    fi
    if [ $? -eq 0 ]; then
        local new_left="${left}${destination} "
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
    _percol_clean_prompt
}
zle -N percol_insert_ls

function percol_cd_repository() {
    local destination
    destination=$(_percol_get_repository_dir)
    [[ $destination != "" ]] && cd ${destination}
    _percol_clean_prompt
}
zle -N percol_cd_repository

# ------------------------------------------------------------
# Define useful commands
# ------------------------------------------------------------

function ppgrep() {
    if [[ $1 == "" ]]; then
        PERCOL=percol
    else
        PERCOL="percol --query $1"
    fi
    ps aux | eval $PERCOL | awk '{ print $2 }'
}

function ppkill() {
    if [[ $1 =~ "^-" ]]; then
        QUERY=""            # options only
    else
        QUERY=$1            # with a query
        [[ $# > 0 ]] && shift
    fi
    ppgrep $QUERY | xargs kill $*
}

