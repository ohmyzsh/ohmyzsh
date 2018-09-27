#!/bin/bash

trap clean_up EXIT
_STTY=$(stty -g)      ## Save current terminal setup
stty -echo            ## Turn off echo

function clean_up() {
  stty "$_STTY"            ## Restore terminal settings
}

function show_help() {
  echo "Usage: $(basename $0) [destination [tar flags]]" 1>& 2
  echo "  If given, the destination specifies the directory to place downloaded files."
  echo "  Further options are passed through to tar. See your system's manpage for tar for details."
}

function bad_input() {
  echo "Bad input: %1" 1>& 2
  exit 1
}

function die() {
  echo "Fatal error: $1" 1>& 2
  exit 1
}

function read_base64_stanza() {
  value=""
  while read line;
  do 
    if [ "$line" == "" ]; then
      break
    fi
    printf "%s" "$line"
  done
}

function decode() {
  VERSION=$(base64 --version 2>&1)
  if [[ "$VERSION" =~ fourmilab ]]; then
    BASE64ARG=-d
  elif [[ "$VERSION" =~ GNU ]]; then
    BASE64ARG=-di
  else
    BASE64ARG=-D
  fi

  base64 "$BASE64ARG" <<< "$1"
}

# tmux requires unrecognized OSC sequences to be wrapped with DCS tmux;
# <sequence> ST, and for all ESCs in <sequence> to be replaced with ESC ESC. It
# only accepts ESC backslash for ST.
function print_osc() {
    if [[ $TERM == screen* ]] ; then
        printf "\033Ptmux;\033\033]"
    else
        printf "\033]"
    fi
}

# More of the tmux workaround described above.
function print_st() {
    if [[ $TERM == screen* ]] ; then
        printf "\a\033\\"
    else
        printf "\a"
    fi
}

function send_request_for_upload() {
  print_osc
  printf '1337;RequestUpload=format=tgz' ""
  print_st
}

location="$PWD"
if [[ $# > 0 ]]
then
  location="$1"
  shift
fi

send_request_for_upload
read status

if [[ $status == ok ]]
then
  data=$(read_base64_stanza)
  clean_up
  decode "$data" | tar -x -z -C "$location" -f - $* 1>& 2
elif [[ $status == abort ]]
then
  echo "Upload aborted" 1>& 2
else
  die "Unknown status: $status" 1>& 2
fi

