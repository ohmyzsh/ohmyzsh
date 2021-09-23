#
# See README.md
#
# Derek Wyatt (derek@{myfirstnamemylastname}.org
# 

function callvim {
  if [[ $# == 0 ]]; then
    cat <<EOH
usage: callvim [-b cmd] [-a cmd] [-n name] [file ... fileN]

  -b cmd     Run this command in GVIM before editing the first file
  -a cmd     Run this command in GVIM after editing the first file
  -n name    Name of the GVIM server to connect to
  file       The file to edit
  ... fileN  The other files to add to the argslist
EOH
    return 0
  fi

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
  do
    case $option in
      a) after="$OPTARG"
         ;;
      b) before="$OPTARG"
         ;;
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
}

alias v=callvim
alias vvsp="callvim -b':vsp'"
alias vhsp="callvim -b':sp'"
alias vk="callvim -b':wincmd k'"
alias vj="callvim -b':wincmd j'"
alias vl="callvim -b':wincmd l'"
alias vh="callvim -b':wincmd h'"
