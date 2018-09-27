#!/bin/bash
# tmux requires unrecognized OSC sequences to be wrapped with DCS tmux;
# <sequence> ST, and for all ESCs in <sequence> to be replaced with ESC ESC. It
# only accepts ESC backslash for ST.
function print_osc() {
    if [ x"$TERM" = "xscreen" ] ; then
        printf "\033Ptmux;\033\033]"
    else
        printf "\033]"
    fi
}

function check_dependency() {
  if ! (builtin command -V "$1" > /dev/null 2>& 1); then
    echo "imgcat: missing dependency: can't find $1" 1>& 2
    exit 1
  fi
}

# More of the tmux workaround described above.
function print_st() {
    if [ x"$TERM" = "xscreen" ] ; then
        printf "\a\033\\"
    else
        printf "\a"
    fi
}

function list_file() {
  fn=$1
  dims=$(php -r 'if (!is_file($argv[1])) exit(1); $a = getimagesize($argv[1]); if ($a==FALSE) exit(1); else { echo $a[0] . "x" .$a[1]; exit(0); }' "$fn")
  rc=$?
  if [[ $rc == 0 ]] ; then
    print_osc
    printf '1337;File=name='`echo -n "$fn" | base64`";"
    wc -c "$fn" | awk '{printf "size=%d",$1}'
    printf ";inline=1;height=3;width=3;preserveAspectRatio=true"
    printf ":"
    base64 < "$fn"
    print_st
    if [ x"$TERM" == "xscreen" ] ; then
      # This works in plain-old tmux but does the wrong thing in iTerm2's tmux
      # integration mode. tmux doesn't know that the cursor moves when the
      # image code is sent, while iTerm2 does. I had to pick one, since
      # integration mode is undetectable, so I picked the failure mode that at
      # least produces useful output (there is just too much whitespace in
      # integration mode). This could be fixed by not moving the cursor while
      # in integration mode. A better fix would be for tmux to interpret the
      # image sequence, though.
      #
      # tl;dr: If you use tmux in integration mode, replace this with the printf
      # from the else clause.
      printf '\033[4C\033[Bx'
    else
      printf '\033[A'
    fi
    echo -n "$dims "
    ls -ld "$fn"
  else
    ls -ld "$fn"
  fi
}

check_dependency php
check_dependency base64
check_dependency wc

if [ $# -eq 0 ]; then
  for fn in *
  do
     list_file "$fn"
  done < <(ls -ls)
else
  for fn in "$@"
  do
     list_file "$fn"
  done
fi

