#!/bin/bash

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

function show_help() {
  echo "Usage:" 1>& 2
  echo "  $(basename $0) start" 1>& 2
  echo "    Begin bouncing the dock icon if another app is active" 1>& 2
  echo "  $(basename $0) stop" 1>& 2
  echo "    Stop bouncing the dock icon if another app is active" 1>& 2
  echo "  $(basename $0) fireworks" 1>& 2
  echo "    Show an explosion animation at the cursor" 1>& 2
}

function start_bounce() {
  print_osc
  printf "1337;RequestAttention=1"
  print_st
}

function stop_bounce() {
  print_osc
  printf "1337;RequestAttention=0"
  print_st
}

function fireworks() {
  print_osc
  printf "1337;RequestAttention=fireworks"
  print_st
}

## Main
if [[ $# == 0 ]]
then
  show_help
  exit 1
fi

if [[ $1 == start ]]
then
  start_bounce
elif [[ $1 == stop ]]
then
  stop_bounce
elif [[ $1 == fireworks ]]
then
  fireworks
else
  show_help
  exit 1
fi

