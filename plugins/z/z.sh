# Copyright (c) 2009 rupa deadwyler under the WTFPL license

# maintains a jump-list of the directories you actually use
#
# INSTALL:
#   * put something like this in your .bashrc/.zshrc:
#     . /path/to/z.sh
#   * cd around for a while to build up the db
#   * PROFIT!!
#   * optionally:
#     set $_Z_CMD in .bashrc/.zshrc to change the command (default z).
#     set $_Z_DATA in .bashrc/.zshrc to change the datafile (default ~/.z).
#     set $_Z_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
#     set $_Z_NO_PROMPT_COMMAND if you're handling PROMPT_COMMAND yourself.
#     set $_Z_EXCLUDE_DIRS to an array of directories to exclude.
#
# USE:
#   * z foo     # cd to most frecent dir matching foo
#   * z foo bar # cd to most frecent dir matching foo and bar
#   * z -r foo  # cd to highest ranked dir matching foo
#   * z -t foo  # cd to most recently accessed dir matching foo
#   * z -l foo  # list matches instead of cd
#   * z -c foo  # restrict matches to subdirs of $PWD

case $- in
 *i*) ;;
   *) echo 'ERROR: z.sh is meant to be sourced, not directly executed.'
esac

[ -d "${_Z_DATA:-$HOME/.z}" ] && {
    echo "ERROR: z.sh's datafile (${_Z_DATA:-$HOME/.z}) is a directory."
}

_z() {

 local datafile="${_Z_DATA:-$HOME/.z}"

 # bail out if we don't own ~/.z (we're another user but our ENV is still set)
 [ -f "$datafile" -a ! -O "$datafile" ] && return

 # add entries
 if [ "$1" = "--add" ]; then
  shift

  # $HOME isn't worth matching
  [ "$*" = "$HOME" ] && return

  # don't track excluded dirs
  local exclude
  for exclude in "${_Z_EXCLUDE_DIRS[@]}"; do
   [ "$*" = "$exclude" ] && return
  done

  # maintain the file
  local tempfile
  tempfile="$(mktemp "$datafile.XXXXXX")" || return
  while read line; do
   [ -d "${line%%\|*}" ] && echo $line
  done < "$datafile" | awk -v path="$*" -v now="$(date +%s)" -F"|" '
   BEGIN {
    rank[path] = 1
    time[path] = now
   }
   $2 >= 1 {
    if( $1 == path ) {
     rank[$1] = $2 + 1
     time[$1] = now
    } else {
     rank[$1] = $2
     time[$1] = $3
    }
    count += $2
   }
   END {
    if( count > 6000 ) {
     for( i in rank ) print i "|" 0.99*rank[i] "|" time[i] # aging
    } else for( i in rank ) print i "|" rank[i] "|" time[i]
   }
  ' 2>/dev/null >| "$tempfile"
  if [ $? -ne 0 -a -f "$datafile" ]; then
   env rm -f "$tempfile"
  else
   env mv -f "$tempfile" "$datafile"
  fi

 # tab completion
 elif [ "$1" = "--complete" ]; then
  while read line; do
   [ -d "${line%%\|*}" ] && echo $line
  done < "$datafile" | awk -v q="$2" -F"|" '
   BEGIN {
    if( q == tolower(q) ) nocase = 1
    split(substr(q,3),fnd," ")
   }
   {
    if( nocase ) {
     for( i in fnd ) tolower($1) !~ tolower(fnd[i]) && $1 = ""
    } else {
     for( i in fnd ) $1 !~ fnd[i] && $1 = ""
    }
    if( $1 ) print $1
   }
  ' 2>/dev/null

 else
  # list/go
  while [ "$1" ]; do case "$1" in
   --) while [ "$1" ]; do shift; local fnd="$fnd $1";done;;
   -*) local opt=${1:1}; while [ "$opt" ]; do case ${opt:0:1} in
        c) local fnd="^$PWD $fnd";;
        h) echo "${_Z_CMD:-z} [-chlrt] args" >&2; return;;
        l) local list=1;;
        r) local typ="rank";;
        t) local typ="recent";;
       esac; opt=${opt:1}; done;;
    *) local fnd="$fnd $1";;
  esac; local last=$1; shift; done
  [ "$fnd" -a "$fnd" != "^$PWD " ] || local list=1

  # if we hit enter on a completion just go there
  case "$last" in
   # completions will always start with /
   /*) [ -z "$list" -a -d "$last" ] && cd "$last" && return;;
  esac

  # no file yet
  [ -f "$datafile" ] || return

  local cd
  cd="$(while read line; do
   [ -d "${line%%\|*}" ] && echo $line
  done < "$datafile" | awk -v t="$(date +%s)" -v list="$list" -v typ="$typ" -v q="$fnd" -F"|" '
   function frecent(rank, time) {
    dx = t-time
    if( dx < 3600 ) return rank*4
    if( dx < 86400 ) return rank*2
    if( dx < 604800 ) return rank/2
    return rank/4
   }
   function output(files, toopen, override) {
    if( list ) {
     cmd = "sort -n >&2"
     for( i in files ) if( files[i] ) printf "%-10s %s\n", files[i], i | cmd
     if( override ) printf "%-10s %s\n", "common:", override > "/dev/stderr"
    } else {
     if( override ) toopen = override
     print toopen
    }
   }
   function common(matches) {
    # shortest match
    for( i in matches ) {
     if( matches[i] && (!short || length(i) < length(short)) ) short = i
    }
    if( short == "/" ) return
    # shortest match must be common to each match. escape special characters in
    # a copy when testing, so we can return the original.
    clean_short = short
    gsub(/[\(\)\[\]\|]/, "\\\\&", clean_short)
    for( i in matches ) if( matches[i] && i !~ clean_short ) return
    return short
   }
   BEGIN { split(q, a, " "); oldf = noldf = -9999999999 }
   {
    if( typ == "rank" ) {
     f = $2
    } else if( typ == "recent" ) {
     f = $3-t
    } else f = frecent($2, $3)
    wcase[$1] = nocase[$1] = f
    for( i in a ) {
     if( $1 !~ a[i] ) delete wcase[$1]
     if( tolower($1) !~ tolower(a[i]) ) delete nocase[$1]
    }
    if( wcase[$1] && wcase[$1] > oldf ) {
     cx = $1
     oldf = wcase[$1]
    } else if( nocase[$1] && nocase[$1] > noldf ) {
     ncx = $1
     noldf = nocase[$1]
    }
   }
   END {
    if( cx ) {
     output(wcase, cx, common(wcase))
    } else if( ncx ) output(nocase, ncx, common(nocase))
   }
  ')"
  [ $? -gt 0 ] && return
  [ "$cd" ] && cd "$cd"
 fi
}

alias ${_Z_CMD:-z}='_z 2>&1'

[ "$_Z_NO_RESOLVE_SYMLINKS" ] || _Z_RESOLVE_SYMLINKS="-P"

if compctl &> /dev/null; then
 [ "$_Z_NO_PROMPT_COMMAND" ] || {
  # zsh populate directory list, avoid clobbering any other precmds
  if [ "$_Z_NO_RESOLVE_SYMLINKS" ]; then
    _z_precmd() {
      _z --add "${PWD:a}"
    }
  else
    _z_precmd() {
      _z --add "${PWD:A}"
    }
  fi
  precmd_functions+=(_z_precmd)
 }
 # zsh tab completion
 _z_zsh_tab_completion() {
  local compl
  read -l compl
  reply=(${(f)"$(_z --complete "$compl")"})
 }
 compctl -U -K _z_zsh_tab_completion _z
elif complete &> /dev/null; then
 # bash tab completion
 complete -o filenames -C '_z --complete "$COMP_LINE"' ${_Z_CMD:-z}
 [ "$_Z_NO_PROMPT_COMMAND" ] || {
  # bash populate directory list. avoid clobbering other PROMPT_COMMANDs.
  echo $PROMPT_COMMAND | grep -q "_z --add" || {
   PROMPT_COMMAND='_z --add "$(pwd '$_Z_RESOLVE_SYMLINKS' 2>/dev/null)" 2>/dev/null;'"$PROMPT_COMMAND"
  }
 }
fi
