# Atom's Editor Zsh plugin
# Atom Editor Zsh plugin's author:
#   https://github.com/msmafra/
#
# Atom Editor's information here:
#   https://atom.io/
# Zsh information
#   https://www.zsh.org/
# Oh My Zsh!
#   https://ohmyz.sh/
#
execName="atom"
atomExists=$( \which "${execName:-NULL}" 2>&1 )

if [[ -f "${atomExists}" ]];then
  : ${ATOM:=atom}
else
  : ${ATOM:-}
  printf "%s\n" "The executable 'atom' could not be found!"
fi

# alias for atom `file[:line[:column]]`
function atomLineNumer() {
# Receives a a file name (./<file_name>) or full file path (/tmp/<file_name.ext>) with the desired line number or file
# name or full file path with the desired line and column numbers all separated by spaces.
# $ atomln /etc/os-release 3
# $ atomln /etc/os-release 3 3

local numInt
numInt='^[0-9]+$'

if [[ $# -eq 3 ]];then
    # Is the first parameter set and is not a number
    if [[ ${1} =~ (${numInt}) ]];then
        printf "%s" "First parameter should be a file name ./<file_name.ext> or a full file path /tmp/<file_name.ext>."
    elif [[  ${2} =~ (${numInt}) && ${3} =~ (${numInt}) ]];then
        "${atomExists}" "${1:-}:${2:-0}:${3:-0}"
    fi
elif [[ $# -eq 2 ]];then
    if [[ ${1} =~ (${numInt}) ]];then
        printf "%s" "First parameter should be a file name ./<file_name> or a full file path /tmp/<file_name.ext>."
    elif [[  ${2} =~ (${numInt}) ]];then
       "${atomExists}" "${1:-}:${2:-0}"
    fi
else
    printf "%s" "$# parameters given 2 (file + line number) or 3 (file + line number + column number) "
fi
}

# The Aliases themselves
if (( $+commands[atom] ));then
alias atomd="${ATOM} --dev"
alias atomf="${ATOM} --foreground"
alias atomh="${ATOM} --help"
alias atomlf="${ATOM} --log-file"
alias atomnw="${ATOM} --new-window"
alias atomps="${ATOM} --profile-startup"
alias atomrp="${ATOM} --resource-path"
alias atoms="${ATOM} --safe"
alias atomb="${ATOM} --benchmark"
alias atombt="${ATOM} --benchmark-test"
alias atomt="${ATOM} --test"
alias atommp="${ATOM} --main-process"
alias atomto="${ATOM} --timeout"
alias atomv="${ATOM} --version"
alias atomw="${ATOM} --wait"
alias atomcws="${ATOM} --clear-window-state"
alias atomeel="${ATOM} --enable-electron-logging"
alias atoma="${ATOM} --add"
alias atomln=atomLineNumer
fi
