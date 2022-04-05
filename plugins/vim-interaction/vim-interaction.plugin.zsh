#
# See README.md
#
# Derek Wyatt (derek@{myfirstnamemylastname}.org
# 

<<<<<<< HEAD
function resolveFile
{
  if [ -f "$1" ]; then
    echo $(readlink -f "$1")
  elif [[ "${1#/}" == "$1" ]]; then
    echo "$PWD/$1"
  else
    echo $1
  fi
}

function callvim
{
  if [[ $# == 0 ]]; then
    cat <<EOH
usage: callvim [-b cmd] [-a cmd] [file ... fileN]

  -b cmd     Run this command in GVIM before editing the first file
  -a cmd     Run this command in GVIM after editing the first file
=======
function callvim {
  if [[ $# == 0 ]]; then
    cat <<EOH
usage: callvim [-b cmd] [-a cmd] [-n name] [file ... fileN]

  -b cmd     Run this command in GVIM before editing the first file
  -a cmd     Run this command in GVIM after editing the first file
  -n name    Name of the GVIM server to connect to
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  file       The file to edit
  ... fileN  The other files to add to the argslist
EOH
    return 0
  fi

<<<<<<< HEAD
  local cmd=""
  local before="<esc>"
  local after=""
  while getopts ":b:a:" option
=======
  # Look up the newest instance or start one
  local name="$(gvim --serverlist | tail -n 1)"
  [[ -n "$name" ]] || {
    # run gvim or exit if it fails
    gvim || return $?

    # wait for gvim instance to fully load
    while name=$(gvim --serverlist) && [[ -z "$name" ]]; do
      sleep 0.1
    done
  }

  local before="<esc>" files after cmd

  while getopts ":b:a:n:" option
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  do
    case $option in
      a) after="$OPTARG"
         ;;
      b) before="$OPTARG"
         ;;
<<<<<<< HEAD
    esac
  done
  shift $((OPTIND-1))
  if [[ ${after#:} != $after && ${after%<cr>} == $after ]]; then
    after="$after<cr>"
  fi
  if [[ ${before#:} != $before && ${before%<cr>} == $before ]]; then
    before="$before<cr>"
  fi
  local files=""
  for f in $@
  do
    files="$files $(resolveFile $f)"
  done
  if [[ -n $files ]]; then
    files=':args! '"$files<cr>"
  fi
  cmd="$before$files$after"
  gvim --remote-send "$cmd"
  if typeset -f postCallVim > /dev/null; then
    postCallVim
  fi
=======
      n) name="$OPTARG"
         ;;
    esac
  done
  shift $((OPTIND-1))

  # If before or after commands begin with : and don't end with <cr>, append it
  [[ ${after}  = :* && ${after}  != *\<cr\> ]] && after+="<cr>"
  [[ ${before} = :* && ${before} != *\<cr\> ]] && before+="<cr>"
  # Open files passed (:A means abs path resolving symlinks, :q means quoting special chars)
  [[ $# -gt 0 ]] && files=':args! '"${@:A:q}<cr>"
  # Pass the built vim command to gvim
  cmd="$before$files$after"

  # Run the gvim command
  gvim --servername "$name" --remote-send "$cmd" || return $?

  # Run postCallVim if defined (maybe to bring focus to gvim, see README)
  (( ! $+functions[postCallVim] )) || postCallVim
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

alias v=callvim
alias vvsp="callvim -b':vsp'"
alias vhsp="callvim -b':sp'"
alias vk="callvim -b':wincmd k'"
alias vj="callvim -b':wincmd j'"
alias vl="callvim -b':wincmd l'"
alias vh="callvim -b':wincmd h'"
