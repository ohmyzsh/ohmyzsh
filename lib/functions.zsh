function zsh_stats() {
  fc -l 1 \
    | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' \
    | grep -v "./" | sort -nr | head -20 | column -c3 -s " " -t | nl
}

function uninstall_oh_my_zsh() {
  env ZSH="$ZSH" sh "$ZSH/tools/uninstall.sh"
}

function upgrade_oh_my_zsh() {
  echo >&2 "${fg[yellow]}Note: \`$0\` is deprecated. Use \`omz update\` instead.$reset_color"
  omz update
}

function takedir() {
  mkdir -p $@ && cd ${@:$#}
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

function takeurl() {
  data=$(mktemp)
  curl -L $1 > $data
  tar xf $data
  thedir=$(tar tf $data | head -1)
  rm $data
  cd $thedir
}

function takegit() {
  git clone $1
  cd $(basename ${1%%.git})
}

function take() {
  if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
    takeurl $1
  elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
    takegit $1
  else
    takedir $1
  fi
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
#  omz_urlencode [-r] [-m] [-P] <string>
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

  local in_str=$1
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
  local decoded
  eval "decoded=\$'$tmp'"

  # Now we have a UTF-8 encoded string in the variable. We need to re-encode
  # it if caller is in a non-UTF-8 locale.
  local safe_encodings
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
# PSK List directories only
lsd() {
    l | grep -E "^d"
}

# ls grep
lsg() {
    l | grep -iE "$1"
}

# These need to be here since they're required by gfind*
alias ag="/usr/local/homebrew/bin/ag --ignore '*.svg' --ignore '*.xlt' --ignore '*.tsx' --ignore '*.js' --ignore '*.snap' --ignore '*.json' --ignore '*.dat' --ignore '*.builds' --ignore '*.tsv' --ignore '*.csv' --ignore '*.lock' --ignore '*.patch' --ignore '*.sum' --pager=bat"
alias ag-no-pager="/usr/local/homebrew/bin/ag --ignore '*.svg' --ignore '*.xlt' --ignore '*.tsx' --ignore '*.js' --ignore '*.snap' --ignore '*.json' --ignore '*.dat' --ignore '*.builds' --ignore '*.tsv' --ignore '*.csv' --ignore '*.lock' --ignore '*.patch' --ignore '*.sum'"
alias "git-grep"="git \grep"

# the ol' gfind. Doesn't take a file pattern.
function gfind-all() {
    # fd -H -t f . -x grep --color=always -Hi ${1}
    # Gah. Bye-bye gfind, here's an off-the-shelf improvement upon it https://github.com/burntsushi/ripgrep
    # $1 is search term, $2 is path
    # rg --no-ignore --hidden "$@"
    # even better is ag / silver searcher https://github.com/ggreer/the_silver_searcher
    ag-no-pager -a --pager bat "$@"
}

# the ol' gfind. Doesn't take a file pattern.
function gfind() {
    # fd -t f . -x grep --color=always -Hi ${1}
    ag-no-pager --pager bat "$@"
}

# Print out the matches only
function gfindf() {
  ack -l $1 --pager=bat --color
}

# function h() {
#   NUM_LINES = ${1:-1000}
#   history | tail -n $NUM_LINES
# }

# function h() {
#   set -x
#   NUM_LINES = ${1:-25}
#   \history -${NUM_LINES}
# }

function agl() {
  ag --pager less "$@"
}

function kill-em-all() {
  NAME=$1

  echo "Attempting to kill $NAME by arg match..."
  pkill -fli $1
  echo "Attempting to kill $NAME by binary match..."
  pkill -li $1
  echo "...the killing... is done"
}

function dateline() {
  echo "––––––––––––"
  date
  echo "––––––––––––"
}

function clean-slate() {
  clear
  dateline
}

alias clr=clean-slate
alias cls=clean-slate

function psgr() {
  ps auwwwwx | grep -v 'grep ' | grep -E "%CPU|$1"
}

function edit() {
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code $1
}

function zshrc() {
  pushd ~/.oh-my-zsh
  edit .
  popd
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

function git-show-all-stashes() {
  echo "Hit 'q' to go to next file"
  echo ""
  git stash list | awk -F: '{ print "\n\n\n\n"; print $0; print "\n\n"; system("git stash show -p " $1); }'
}

# kill most recent container instance
alias docker-kill-latest='docker ps -l --format="{{.Names}}" | xargs docker kill'

# stop all containers
function docker-stop-all-containers () {
  docker container stop -t 2 $(docker container ls -q) 2>/dev/null ; echo ""
}

function docker-lsg () {
  docker image ls | grep -Ei "'IMAGE ID'|$1"
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

goclean() {
 local pkg=$1; shift || return 1
 local ost
 local cnt
 local scr

 # Clean removes object files from package source directories (ignore error)
 go clean -i $pkg &>/dev/null

 # Set local variables
 [[ "$(uname -m)" == "x86_64" ]] \
 && ost="$(uname)";ost="${ost,,}_amd64" \
 && cnt="${pkg//[^\/]}"

 # Delete the source directory and compiled package directory(ies)
 if (("${#cnt}" == "2")); then
  rm -rf "${GOPATH%%:*}/src/${pkg%/*}"
  rm -rf "${GOPATH%%:*}/pkg/${ost}/${pkg%/*}"
 elif (("${#cnt}" > "2")); then
  rm -rf "${GOPATH%%:*}/src/${pkg%/*/*}"
  rm -rf "${GOPATH%%:*}/pkg/${ost}/${pkg%/*/*}"
 fi
}

function _open-all-chrome-apps() {
  for APP in "${1}"/*.app; do
    echo "Opening $APP ..."
    nohup open -a "$APP" > /dev/null 2>&1 &
  done
}

function open-all-chrome-apps() {
  CHROME_APP_DIR='/Users/peter/Dropbox (Personal)/_Settings/Chrome Apps/Chrome Apps.localized'
  _open-all-chrome-apps $CHROME_APP_DIR
  CHROME_APP_DIR='/Users/peter/Dropbox (Personal)/_Settings/Chrome/Chrome Apps/Chrome Apps.localized'
  _open-all-chrome-apps $CHROME_APP_DIR
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

# Include Rune funcs
. $HOME/.oh-my-zsh/rune-shell-funcs.zsh

zle -N peco-directories
bindkey '^Xf' peco-directories
zle -N peco-files
bindkey '^X^f' peco-files

### peco functions ###
