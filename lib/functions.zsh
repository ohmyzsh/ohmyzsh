source ~/.oh-my-zsh/work-functions.zsh

function zsh_stats() {
  fc -l 1 \
    | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' \
    | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
}

function uninstall_oh_my_zsh() {
  env ZSH="$ZSH" sh "$ZSH/tools/uninstall.sh"
}

function upgrade_oh_my_zsh() {
  echo >&2 "${fg[yellow]}Note: \`$0\` is deprecated. Use \`omz update\` instead.$reset_color"
  omz update
}

function open_command() {
  local open_cmd

  # define the open command
  case "$OSTYPE" in
    darwin*)  open_cmd='open' ;;
    cygwin*)  open_cmd='cygstart' ;;
    linux*)   [[ "$(uname -r)" != *icrosoft* ]] && open_cmd='nohup xdg-open' || {
                open_cmd='cmd.exe /c start ""'
                [[ -e "$1" ]] && { 1="$(wslpath -w "${1:a}")" || return 1 }
              } ;;
    msys*)    open_cmd='start ""' ;;
    *)        echo "Platform $OSTYPE not supported"
              return 1
              ;;
  esac

  ${=open_cmd} "$@" &>/dev/null
}

# take functions

# mkcd is equivalent to takedir
function mkcd takedir() {
  mkdir -p $@ && cd ${@:$#}
}

function takeurl() {
  local data thedir
  data="$(mktemp)"
  curl -L "$1" > "$data"
  tar xf "$data"
  thedir="$(tar tf "$data" | head -n 1)"
  rm "$data"
  cd "$thedir"
}

function takegit() {
  git clone "$1"
  cd "$(basename ${1%%.git})"
}

function take() {
  if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
    takeurl "$1"
  elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
    takegit "$1"
  else
    takedir "$@"
  fi
}

alias gdi="git diff --cached "
alias gdc="git diff --cached "

# Params: branch A and branch B to be diffed
function gdb() {
  git diff $1..$2
}

#
# Get the value of an alias.
#
# Arguments:
#    1. alias - The alias to get its value from
# STDOUT:
#    The value of alias $1 (if it has one).
# Return value:
#    0 if the alias was found,
#    1 if it does not exist
#
function alias_value() {
    (( $+aliases[$1] )) && echo $aliases[$1]
}

#
# Try to get the value of an alias,
# otherwise return the input.
#
# Arguments:
#    1. alias - The alias to get its value from
# STDOUT:
#    The value of alias $1, or $1 if there is no alias $1.
# Return value:
#    Always 0
#
function try_alias_value() {
    alias_value "$1" || echo "$1"
}

#
# Set variable "$1" to default value "$2" if "$1" is not yet defined.
#
# Arguments:
#    1. name - The variable to set
#    2. val  - The default value
# Return value:
#    0 if the variable exists, 3 if it was set
#
function default() {
    (( $+parameters[$1] )) && return 0
    typeset -g "$1"="$2"   && return 3
}

#
# Set environment variable "$1" to default value "$2" if "$1" is not yet defined.
#
# Arguments:
#    1. name - The env variable to set
#    2. val  - The default value
# Return value:
#    0 if the env variable exists, 3 if it was set
#
function env_default() {
    [[ ${parameters[$1]} = *-export* ]] && return 0
    export "$1=$2" && return 3
}


# Required for $langinfo
zmodload zsh/langinfo

# URL-encode a string
#
# Encodes a string using RFC 2396 URL-encoding (%-escaped).
# See: https://www.ietf.org/rfc/rfc2396.txt
#
# By default, reserved characters and unreserved "mark" characters are
# not escaped by this function. This allows the common usage of passing
# an entire URL in, and encoding just special characters in it, with
# the expectation that reserved and mark characters are used appropriately.
# The -r and -m options turn on escaping of the reserved and mark characters,
# respectively, which allows arbitrary strings to be fully escaped for
# embedding inside URLs, where reserved characters might be misinterpreted.
#
# Prints the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#  omz_urlencode [-r] [-m] [-P] <string> [<string> ...]
#
#    -r causes reserved characters (;/?:@&=+$,) to be escaped
#
#    -m causes "mark" characters (_.!~*''()-) to be escaped
#
#    -P causes spaces to be encoded as '%20' instead of '+'
function omz_urlencode() {
  emulate -L zsh
  local -a opts
  zparseopts -D -E -a opts r m P

  local in_str="$@"
  local url_str=""
  local spaces_as_plus
  if [[ -z $opts[(r)-P] ]]; then spaces_as_plus=1; fi
  local str="$in_str"

  # URLs must use UTF-8 encoding; convert str to UTF-8 if required
  local encoding=$langinfo[CODESET]
  local safe_encodings
  safe_encodings=(UTF-8 utf8 US-ASCII)
  if [[ -z ${safe_encodings[(r)$encoding]} ]]; then
    str=$(echo -E "$str" | iconv -f $encoding -t UTF-8)
    if [[ $? != 0 ]]; then
      echo "Error converting string from $encoding to UTF-8" >&2
      return 1
    fi
  fi

  # Use LC_CTYPE=C to process text byte-by-byte
  local i byte ord LC_ALL=C
  export LC_ALL
  local reserved=';/?:@&=+$,'
  local mark='_.!~*''()-'
  local dont_escape="[A-Za-z0-9"
  if [[ -z $opts[(r)-r] ]]; then
    dont_escape+=$reserved
  fi
  # $mark must be last because of the "-"
  if [[ -z $opts[(r)-m] ]]; then
    dont_escape+=$mark
  fi
  dont_escape+="]"

  # Implemented to use a single printf call and avoid subshells in the loop,
  # for performance (primarily on Windows).
  local url_str=""
  for (( i = 1; i <= ${#str}; ++i )); do
    byte="$str[i]"
    if [[ "$byte" =~ "$dont_escape" ]]; then
      url_str+="$byte"
    else
      if [[ "$byte" == " " && -n $spaces_as_plus ]]; then
        url_str+="+"
      else
        ord=$(( [##16] #byte ))
        url_str+="%$ord"
      fi
    fi
  done
  echo -E "$url_str"
}

# URL-decode a string
#
# Decodes a RFC 2396 URL-encoded (%-escaped) string.
# This decodes the '+' and '%' escapes in the input string, and leaves
# other characters unchanged. Does not enforce that the input is a
# valid URL-encoded string. This is a convenience to allow callers to
# pass in a full URL or similar strings and decode them for human
# presentation.
#
# Outputs the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#   omz_urldecode <urlstring>  - prints decoded string followed by a newline
function omz_urldecode {
  emulate -L zsh
  local encoded_url=$1

  # Work bytewise, since URLs escape UTF-8 octets
  local caller_encoding=$langinfo[CODESET]
  local LC_ALL=C
  export LC_ALL

  # Change + back to ' '
  local tmp=${encoded_url:gs/+/ /}
  # Protect other escapes to pass through the printf unchanged
  tmp=${tmp:gs/\\/\\\\/}
  # Handle %-escapes by turning them into `\xXX` printf escapes
  tmp=${tmp:gs/%/\\x/}
  local decoded="$(printf -- "$tmp")"

  # Now we have a UTF-8 encoded string in the variable. We need to re-encode
  # it if caller is in a non-UTF-8 locale.
  local -a safe_encodings
  safe_encodings=(UTF-8 utf8 US-ASCII)
  if [[ -z ${safe_encodings[(r)$caller_encoding]} ]]; then
    decoded=$(echo -E "$decoded" | iconv -f UTF-8 -t $caller_encoding)
    if [[ $? != 0 ]]; then
      echo "Error converting string from UTF-8 to $caller_encoding" >&2
      return 1
    fi
  fi

  echo -E "$decoded"
}

##################################
# PSK Functions
##################################
# ls grep
lsg() {
    la | grep --color=always -iE "$1"
}

beenv() {
  echo "\$MYSQL_USER=$MYSQL_USER"
  echo "\$MYSQL_PASSWORD=$MYSQL_PASSWORD"
  echo "\$MYSQL_HOST_IP=$MYSQL_HOST_IP"
  echo "\$PYTHONPATH=$PYTHONPATH"
  echo "\$TEST_DB=$TEST_DB"
}

alg () {
  FN=/tmp/alg.$$
  echo -e "\nAliases ———————" > $FN
  alias | grep --color=always --ignore-case -h --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -i $1 >> $FN
  echo -e "\nFunctions ———————" >> $FN
  functions | grep --color=always --ignore-case -h --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -i $1 >> $FN
  less $FN
  rm -f $FN
}
alias agr="alg"
alias alias-grep="alg"

# These need to be here since they're required by gfind*
alias ag-no-pager="/opt/homebrew/bin/ag --ignore '*.snap' --ignore '*.dat' --ignore '*.builds' --ignore '*.tsv' --ignore '*.csv' --ignore '*.lock' --ignore '*.patch' --ignore '*.sum' --ignore-dir={venv,node_modules,mounts}"
alias ag="ag-no-pager --pager=bat"
alias "git-grep"="git \grep"

function make-break() {
  echo -e "—————————————————————————————————————————— \
  \n\n——————————————————————————————————————————\n"
}

# Spits out a page of alternating white lines (hypens or thereabouts)
function page-break() {
  lines-break 9
}

function lines-break(){
  for i in {1..$1}; do;
    make-break
  done
  today-time
}

function half-page-break() {
  lines-break 3
}

function today-time() {
  echo "————————————\n"
  date +"%a %l:%M%p"
  echo "\n————————————"
}

alias make-big-break=page-break
alias space=page-break

# the ol' gfind. Doesn't take a file pattern.
function gfind-all() {
    # fd -H -t f . -x grep --color=always -Hi ${1}
    # Gah. Bye-bye gfind, here's an off-the-shelf improvement upon it https://github.com/burntsushi/ripgrep
    # $1 is search term, $2 is path
    # rg --no-ignore --hidden "$@"
    # even better is ag / silver searcher https://github.com/ggreer/the_silver_searcher
    ag-no-pager --ignore-case --hidden --ignore-case --pager bat "$@"
}

function gfind-all-only-matching-files() {
    ag-no-pager --ignore-case --hidden --ignore-case --pager bat --count "$@"
}

# the ol' gfind. Doesn't take a file pattern.
function gfind() {
    # fd -t f . -x grep --color=always -Hi ${1}
    ag-no-pager --ignore-case --pager bat "$@"
}

function gfind-only-matching-files() {
    ag-no-pager --ignore-case --pager bat --count "$@"
}

# Print out the matches only
function gfindf() {
  ack -l $1 --pager=less --color
}

batdiff() {
    git diff --name-only --diff-filter=d | xargs bat --diff
}

function agl() {
  ag --pager bat "$@"
}

function lsofgr() {
  sudo lsof -i -P | grep -E "$1|COMMAND" | grep -E "$1|:"
}

function kill-em-all() {
  NAME=$1

  echo "Attempting to kill $NAME by arg match..."
  pkill -fli $1
  MATCHED_BY_ARG=$?
  echo "Attempting to kill $NAME by binary match..."
  pkill -li $1
  MATCHED_BY_BIN=$?

  sleep 3
  # if [[ "$MATCHED_BY_ARG" -ne 0 && "$MATCHED_BY_BIN" -ne 0 ]]; then
    echo "Right, getting the machete out - brutally killing $NAME..."
    pkill -9 -li $1
    pkill -9 -fli $1
  # fi

  echo "...the killing... is done"
}

function dateline() {
  echo -e "\n––––––––––––"
  date
  echo -e "––––––––––––\n"
}

function clean-slate() {
  clear
  dateline
}

alias clr=clean-slate
alias cls=clean-slate

function print-hashes() {
  repeat $1 echo -n "#" ; echo
}
function h() {
    # check if we passed any parameters
    if [ -z "$*" ]; then
        # if no parameters were passed print entire history
        print-hashes 60
        history -200
        print-hashes 60
    else
        # if words were passed use it as a search
        history 1 | egrep --color=auto "$@"
    fi
}

# function h() {
#   print-hashes 60
#   NUM_LINES=$1
#   if [ -z "$NUM_LINES" ]; then
#       NUM_LINES=35
#   fi
#   history -$NUM_LINES
#   print-hashes 60
# }


function psgr () {
  # echo "  UID   PID  PPID   C STIME   TTY           TIME CMD"
  # ps -h -A -o %cpu,%mem,command,cputime,state,user,pid,ppid,ruser,start,time,tt,tty | \grep -v 'grep ' | awk '{$1=$1};1' | \grep -iE "$1"
  ps -ef | \grep -v 'grep ' | awk '{$1=$1};1' | \grep -iE "$1|PPID"
}

# Sort on the command
function psgr-sorted() {
  echo "  UID   PID  PPID   C STIME   TTY           TIME CMD"
  ps -ef | grep -v 'grep ' | awk '{$1=$1};1' | grep -iE "$1" | sort -k 4
}

psgr-pid-only () {
  ps -e | \grep -v 'grep ' | awk '{$1=$1};1' | \grep -iE "$1" | cut -f 1 -d" "
}

kill-em-all () {
  PROCESS_NAME=$1
  echo "This will absolutely kill all processes matching *$PROCESS_NAME*. Are you sure?"
  read  -n 1
  psgr-pid-only $PROCESS_NAME|cut -f 1 -d" "| tr '\n' ' ' | xargs kill -9
  RES=$?
  echo "RES: • ${RES} •"
}

function list-app-url-schemes() {
  defaults read /Applications/${1}.app/Contents/Info.plist CFBundleURLTypes
}
alias url-schemes-of-app=list-app-url-schemes

function lsofgr-listen() {
  echo "Searching for processes listening on port $1..."
  #echo "ℹ️ lsof can take up to 2 minutes to complete"
  # --stdin Wr   the prompt to the standard error and read the password from the standard input instead of using the terminal device.
  sudo --stdin < <(echo "11anfair") lsof -i -P | grep -E "COMMAND|.*:$1.*LISTEN"
}
alias port-grep=lsofgr

function edit() {
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code $1
}

function zshrc() {
  pushd ~/.oh-my-zsh
  edit .
  popd
}


function what-is-my-ip() {
  ifconfig en0 | awk -v OFS="\n" '{ print $1 " " $2, $NF }' | grep "inet 192"
}

function dir-sizes() {
  du -sh ./* | sort -h
}

# Call from within the source TLD
function download-sources-intellij() {
  mvn dependency:sources
  mvn dependency:resolve -Dclassifier=javadoc
}


function ssh-ds718() {
  ssh -p 658 pskadmin@192.168.2.7
}

alias git-stash-list-all='gitk `git stash list --pretty=format:%gd`'

function git-show-protection() {
  git branch -vv | grep "origin/`git branch --show-current`"
}

function git-show-branch() {
  git branch -vv | grep `git branch --show-current`
}

function git-show-stash() {
  git stash show stash@{$1}
}
alias gss="git-show-stash"

function git-apply-stash() {
  git stash apply stash@{$1}
}
alias gas="git-apply-stash"
alias gsa="git-apply-stash"

function git-show-all-stashes() {
  echo "Hit 'q' to go to next file"
  echo ""
  git stash list | awk -F: '{ print "\n\n\n\n"; print $0; print "\n\n"; system("git stash show -p " $1); }'
}
alias gsas="git-show-all-stashes"

# Check whether the supplied file is under SCM/git.
# Check whether the supplied file is under SCM/git.
function git-status() {
  git ls-files | grep $1
}

function find-gig-files() {
  find . -size +1G -ls | sort -k7n # Find files larger than 1GB and then order the list by the file size
}

function _start-cloud-storage() {
    bgnotify "Booting cloud sync apps..."
    cd /Applications
    open Dropbox.app 2>/dev/null &
    open Google\ Drive.app 2>/dev/null &
    # Don't do this cos it downloads my backed up photos
    # open "Google Drive File Stream.app" 2>/dev/null &
    cd -
}

function start-cloud-storage() {
  (
    bgnotify "Waiting for local unison sync..."
    /Users/peter/dotfiles_psk/bin/unison-cron-job.sh
    sleep 7
    _start-cloud-storage
  ) &
}

# Out of action - needs work
# function tree() {
#   DIR=$1 ;
#   shift # kubectl create -f hello-k8s-replicaset.yaml
# ps $1 off
#   /usr/local/homebrew/bin/tree -a $DIR | colorize_less "$@"
# }

function space() {
  echo;echo;echo;echo;echo;
}

alias s="space"

function open-job-docs() {
  open 'https://docs.google.com/document/d/1O81om1F14fNhWhqt5VpIULfiCHmNXPkFcMoED09cidU/edit'
  open 'https://docs.google.com/document/d/1pBJfqcWhn9Wz6p6wPpPrk6_9MdGG_24qmpluz4pM3AY/edit'
  open 'https://docs.google.com/document/d/1nj_MidYJEDhk1uzhPFOZ6uFdXfZY2hdrV0_f8zJ4Lgs/edit'
  open 'https://docs.google.com/document/d/1gPNcLjrZJnJnWy0-k5SqpgP4VAUZ_ikRLR9qYEB50M0/edit'
}

function open-all-chrome-apps() {
  /Users/peter/.oh-my-zsh/bin/launch-browser-apps.sh & 2>&1 > /dev/null
}

function post-boot-tasks() {
    open-all-chrome-apps
    docker-stop-all
}

function kill-cloud-storage() {
    # TODO investigate pkill as alternative

    # Don't do this cos it downloads my backed up photos
    # killall "Google Drive File Stream" 2>/dev/null &
    killall Dropbox 2>/dev/null &
    killall "Google Drive" 2>/dev/null &
    killall -v "FinderSyncExtension" -SIGKILL &
}

function mdfind() {
    /usr/bin/mdfind $@ 2> >(grep --invert-match ' \[UserQueryParser\] ' >&2)
}

function mdfind-current-dir() { # find file in .
  mdfind -onlyin . -name $1
}

function mdfind-home-dir() { # mdfind file in $HOME
  mdfind -onlyin $HOME -name $1
}

function mdfind-grep-current-dir() { # mdfind grep in current dir
  mdfind -onlyin . $1
}

function mdfind-grep-home-dir() { # mdfind grep in $HOME
  mdfind -onlyin $HOME $1
}


function google-search() {
  s $1 -p google
}

function amazon-search() {
  s $1 -p amazon
}

function youtube-search() {
  s $1 -p youtube
}

function explain-command {
    command="https://explainshell.com/explain?cmd=${1}"
osascript <<EOD
tell application "Safari" to make new document with properties {URL:"$command"}
return
EOD

}

alias explainer="explain-command"
alias explain-args="explain-command"

### peco functions ###
function peco-directories() {
  local current_lbuffer="$LBUFFER"
  local current_rbuffer="$RBUFFER"
  if command -v fd >/dev/null 2>&1; then
    local dir="$(command \fd --type directory --hidden --no-ignore --exclude .git/ --color never 2>/dev/null | peco )"
  else
    local dir="$(
      command find \( -path '*/\.*' -o -fstype dev -o -fstype proc \) -type d -print 2>/dev/null \
      | sed 1d \
      | cut -b3- \
      | awk '{a[length($0)" "NR]=$0}END{PROCINFO["sorted_in"]="@ind_num_asc"; for(i in a) print a[i]}' - \
      | peco
    )"
  fi

  if [ -n "$dir" ]; then
    dir=$(echo "$dir" | tr -d '\n')
    dir=$(printf %q "$dir")
    # echo "PSK ${dir}"

    BUFFER="${current_lbuffer}${file}${current_rbuffer}"
    CURSOR=$#BUFFER
  fi
}

function peco-files() {
  local current_lbuffer="$LBUFFER"
  local current_rbuffer="$RBUFFER"
  if command -v fd >/dev/null 2>&1; then
    local file="$(command \fd --type file --hidden --no-ignore --exclude .git/ --color never 2>/dev/null | peco)"
  elif command -v rg >/dev/null 2>&1; then
    local file="$(rg --glob "" --files --hidden --no-ignore-vcs --iglob !.git/ --color never 2>/dev/null | peco)"
  elif command -v ag >/dev/null 2>&1; then
    local file="$(ag --files-with-matches --unrestricted --skip-vcs-ignores --ignore .git/ --nocolor -g "" 2>/dev/null | peco)"
  else
    local file="$(
    command find \( -path '*/\.*' -o -fstype dev -o -fstype proc \) -type f -print 2> /dev/null \
      | sed 1d \
      | cut -b3- \
      | awk '{a[length($0)" "NR]=$0}END{PROCINFO["sorted_in"]="@ind_num_asc"; for(i in a) print a[i]}' - \
      | peco
    )"
  fi

  if [ -n "$file" ]; then
    file=$(echo "$file" | tr -d '\n')
    file=$(printf %q "$file")
    BUFFER="${current_lbuffer}${file}${current_rbuffer}"
    CURSOR=$#BUFFER
  fi
}

zle -N peco-directories
bindkey '^Xf' peco-directories
zle -N peco-files
bindkey '^X^f' peco-files

###########################
# Percol https://github.com/mooz/percol
###########################
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

function smileys() {
  printf "$(awk 'BEGIN{c=127;while(c++<191){printf("\xf0\x9f\x98\\%s",sprintf("%o",c));}}')"
}

function clone-starred-repos() {
  GITUSER=sming; curl "https://api.github.com/users/${GITUSER}/starred?per_page=1000" | grep -o 'git@[^"]*' | parallel -j 25 'git clone {}'
}

function print-path() {
  echo "$PATH" | tr ':' '\n'
}

alias pretty-print-path="print-path"
alias dump-path="print-path"
alias path-dump="print-path"

function envgr() {
  env | grep -Ei "$@" | sort
}

alias interactive-ps-grep="ppgrep"
alias grep-ps-percol="ppgrep"
alias grep-ps-interactive="ppgrep"
alias interactive-kill="ppkill"
alias kill-interactive="ppkill"
alias kill-percol="ppkill"

# From https://apple.stackexchange.com/a/432408/100202 - sets the current iterm2
# tab to a random color
PRELINE="\r\033[A"

# From https://stackoverflow.com/questions/59090903/is-there-any-way-to-get-iterm2-to-color-each-new-tab-with-a-different-color-usi
function random {
    echo -e "\033]6;1;bg;red;brightness;$((1 + $RANDOM % 255))\a"$PRELINE
    echo -e "\033]6;1;bg;green;brightness;$((1 + $RANDOM % 255))\a"$PRELINE
    echo -e "\033]6;1;bg;blue;brightness;$((1 + $RANDOM % 255))\a"$PRELINE
}

function color {
    case $1 in
    green)
    echo -e "\033]6;1;bg;red;brightness;57\a"$PRELINE
    echo -e "\033]6;1;bg;green;brightness;197\a"$PRELINE
    echo -e "\033]6;1;bg;blue;brightness;77\a"$PRELINE
    ;;
    red)
    echo -e "\033]6;1;bg;red;brightness;270\a"$PRELINE
    echo -e "\033]6;1;bg;green;brightness;60\a"$PRELINE
    echo -e "\033]6;1;bg;blue;brightness;83\a"$PRELINE
    ;;
    orange)
    echo -e "\033]6;1;bg;red;brightness;227\a"$PRELINE
    echo -e "\033]6;1;bg;green;brightness;143\a"$PRELINE
    echo -e "\033]6;1;bg;blue;brightness;10\a"$PRELINE
    ;;
    *)
    random
    esac
}

function git-diff-repos() {
  RESULTS="diff-results.patch"
  echo "" > $RESULTS

  for DIR in */; do
    pushd $DIR
    echo "\n———————\nGit diffing $PWD\n———————\n" >> ../$RESULTS
    git --no-pager diff --ignore-space-change -- ':!*poetry.lock' -- ':^.vscode' . >> ../$RESULTS
    popd
  done

  bat $RESULTS
}

function git-info-repos() {
  RESULTS="info-results.txt"
  echo "" > $RESULTS

  for DIR in */; do
    pushd $DIR
    echo "\n———————\nGit info-ing $PWD\n———————\n" >> ../$RESULTS
    git-info 2>&1 >> ../$RESULTS
    popd
  done

  bat $RESULTS
}

function git-merge-develop() {
  echo "\nChecking out develop..." && gco develop && \
  echo "\nPulling develop..." && git pull && \
  echo "\nChecking out -..." && gco - && \
  echo "\nMerging develop in..." && git merge develop
}

function scrcpy-s20() {
  # presumably this once worked but does not now
  # /opt/homebrew/bin/scrcpy --serial R5CN20MZEKJ
  /opt/homebrew/bin/scrcpy -sadb-R5CN20MZEKJ-ogJwLS._adb-tls-connect._tcp.
  if [[ "$?" -ne 0 ]]
  then
    echo "first run usually fails, trying a second time..."
  fi
}
alias run-scrcpy=launch-scrcpy
alias scr=launch-scrcpy


function dir-with-most-files() {
  ~/bin/dir-with-most-files.sh "$@"
}

alias most-files-dir=dir-with-most-files
alias count-files=dir-with-most-files
alias biggest-dirs=dir-with-most-files
