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
  echo "  $(basename $0) set 8" 1>& 2
  echo "  $(basename $0) set 9" 1>& 2
  echo "  $(basename $0) push [name]" 1>& 2
  echo "     Saves the current version with an optional name." 1>& 2
  echo "  $(basename $0) pop [name]" 1>& 2
  echo "     If name is given, all versions up to and including the one with the matching name are popped." 1>& 2
}

function set_version() {
  print_osc
  printf "1337;UnicodeVersion=$1"
  print_st
}

function push_version() {
  print_osc
  printf "1337;UnicodeVersion=push $1"
  print_st
}

function pop_version() {
  print_osc
  printf "1337;UnicodeVersion=pop $1"
  print_st
}

## Main
if [[ $# == 0 ]]
then
  show_help
  exit 1
fi

if [[ $1 == set ]]
then
  if [[ $# != 2 ]]
  then
    show_help
    exit 1
  fi
  set_version $2
elif [[ $1 == push ]]
then
  if [[ $# == 1 ]]
  then
    push_version ""
  elif [[ $# == 2 ]]
  then
    if [[ $2 == "" ]]
    then
      echo "Name must not be empty" 1>& 2
      exit 1
    fi
    push_version "$2"
  else
    show_help
    exit 1
  fi
elif [[ $1 == pop ]]
then
  if [[ $# == 1 ]]
  then
    pop_version ""
  elif [[ $# == 2 ]]
  then
    if [[ $2 == "" ]]
    then
      echo "Name must not be empty" 1>& 2
      exit 1
    fi
    pop_version "$2"
  else
    show_help
    exit 1
  fi
else
  show_help
  exit 1
fi

