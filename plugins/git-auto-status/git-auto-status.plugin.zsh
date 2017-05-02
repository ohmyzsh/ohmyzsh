#
# Run git status after specified set of command
#
# @author Oleksandr Shybystyi oleksandr.shybystyi@gmail.com
#

# default list of git commands `git status` is running after
gitPreAutoStatusCommands=(
    'add'
    'rm'
    'reset'
    'commit'
    'checkout'
)

# taken from http://stackoverflow.com/a/8574392/4647743
function elementInArray() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

function git() {
    command git $@

    if (elementInArray $1 $gitPreAutoStatusCommands); then
        command git status
    fi
}
