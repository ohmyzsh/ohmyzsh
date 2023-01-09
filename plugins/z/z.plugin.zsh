################################################################################
# Zsh-z - jump around with Zsh - A native Zsh version of z without awk, sort,
# date, or sed
#
# https://github.com/agkozak/zsh-z
#
# Copyright (c) 2018-2022 Alexandros Kozak
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# z (https://github.com/rupa/z) is copyright (c) 2009 rupa deadwyler and
# licensed under the WTFPL license, Version 2.
#
# Zsh-z maintains a jump-list of the directories you actually use.
#
# INSTALL:
#   * put something like this in your .zshrc:
#       source /path/to/zsh-z.plugin.zsh
#   * cd around for a while to build up the database
#
# USAGE:
#   * z foo       cd to the most frecent directory matching foo
#   * z foo bar   cd to the most frecent directory matching both foo and bar
#                   (e.g. /foo/bat/bar/quux)
#   * z -r foo    cd to the highest ranked directory matching foo
#   * z -t foo    cd to most recently accessed directory matching foo
#   * z -l foo    List matches instead of changing directories
#   * z -e foo    Echo the best match without changing directories
#   * z -c foo    Restrict matches to subdirectories of PWD
#   * z -x        Remove a directory (default: PWD) from the database
#   * z -xR       Remove a directory (default: PWD) and its subdirectories from
#                   the database
#
# ENVIRONMENT VARIABLES:
#
#   ZSHZ_CASE -> if `ignore', pattern matching is case-insensitive; if `smart',
#     pattern matching is case-insensitive only when the pattern is all
#     lowercase
#   ZSHZ_CMD -> name of command (default: z)
#   ZSHZ_COMPLETION -> completion method (default: 'frecent'; 'legacy' for
#     alphabetic sorting)
#   ZSHZ_DATA -> name of datafile (default: ~/.z)
#   ZSHZ_EXCLUDE_DIRS -> array of directories to exclude from your database
#     (default: empty)
#   ZSHZ_KEEP_DIRS -> array of directories that should not be removed from the
#     database, even if they are not currently available (default: empty)
#   ZSHZ_MAX_SCORE -> maximum combined score the database entries can have
#     before beginning to age (default: 9000)
#   ZSHZ_NO_RESOLVE_SYMLINKS -> '1' prevents symlink resolution
#   ZSHZ_OWNER -> your username (if you want use Zsh-z while using sudo -s)
#   ZSHZ_UNCOMMON -> if 1, do not jump to "common directories," but rather drop
#     subdirectories based on what the search string was (default: 0)
################################################################################

autoload -U is-at-least

if ! is-at-least 4.3.11; then
  print "Zsh-z requires Zsh v4.3.11 or higher." >&2 && exit
fi

############################################################
# The help message
#
# Globals:
#   ZSHZ_CMD
############################################################
_zshz_usage() {
  print "Usage: ${ZSHZ_CMD:-${_Z_CMD:-z}} [OPTION]... [ARGUMENT]
Jump to a directory that you have visited frequently or recently, or a bit of both, based on the partial string ARGUMENT.

With no ARGUMENT, list the directory history in ascending rank.

  --add Add a directory to the database
  -c    Only match subdirectories of the current directory
  -e    Echo the best match without going to it
  -h    Display this help and exit
  -l    List all matches without going to them
  -r    Match by rank
  -t    Match by recent access
  -x    Remove a directory from the database (by default, the current directory)
  -xR   Remove a directory and its subdirectories from the database (by default, the current directory)" |
    fold -s -w $COLUMNS >&2
}

# Load zsh/datetime module, if necessary
(( $+EPOCHSECONDS )) || zmodload zsh/datetime

# Load zsh/files, if necessary
[[ ${builtins[zf_chown]} == 'defined' &&
   ${builtins[zf_mv]}    == 'defined' &&
   ${builtins[zf_rm]}    == 'defined' ]] ||
  zmodload -F zsh/files b:zf_chown b:zf_mv b:zf_rm

# Load zsh/system, if necessary
[[ ${modules[zsh/system]} == 'loaded' ]] || zmodload zsh/system &> /dev/null

# Global associative array for internal use
typeset -gA ZSHZ

# Make sure ZSHZ_EXCLUDE_DIRS has been declared so that other scripts can
# simply append to it
(( ${+ZSHZ_EXCLUDE_DIRS} )) || typeset -gUa ZSHZ_EXCLUDE_DIRS

# Determine if zsystem flock is available
zsystem supports flock &> /dev/null && ZSHZ[USE_FLOCK]=1

# Determine if `print -v' is supported
is-at-least 5.3.0 && ZSHZ[PRINTV]=1

############################################################
# The Zsh-z Command
#
# Globals:
#   ZSHZ
#   ZSHZ_CASE
#   ZSHZ_COMPLETION
#   ZSHZ_DATA
#   ZSHZ_DEBUG
#   ZSHZ_EXCLUDE_DIRS
#   ZSHZ_KEEP_DIRS
#   ZSHZ_MAX_SCORE
#   ZSHZ_OWNER
#
# Arguments:
#   $* Command options and arguments
############################################################
zshz() {

  # Don't use `emulate -L zsh' - it breaks PUSHD_IGNORE_DUPS
  setopt LOCAL_OPTIONS NO_KSH_ARRAYS NO_SH_WORD_SPLIT EXTENDED_GLOB
  (( ZSHZ_DEBUG )) && setopt LOCAL_OPTIONS WARN_CREATE_GLOBAL

  local REPLY
  local -a lines

  # Allow the user to specify the datafile name in $ZSHZ_DATA (default: ~/.z)
  # If the datafile is a symlink, it gets dereferenced
  local datafile=${${ZSHZ_DATA:-${_Z_DATA:-${HOME}/.z}}:A}

  # If the datafile is a directory, print a warning and exit
  if [[ -d $datafile ]]; then
    print "ERROR: Zsh-z's datafile (${datafile}) is a directory." >&2
    exit
  fi

  # Make sure that the datafile exists before attempting to read it or lock it
  # for writing
  [[ -f $datafile ]] || touch "$datafile"

  # Bail if we don't own the datafile and $ZSHZ_OWNER is not set
  [[ -z ${ZSHZ_OWNER:-${_Z_OWNER}} && -f $datafile && ! -O $datafile ]] &&
    return

  # Load the datafile into an array and parse it
  lines=( ${(f)"$(< $datafile)"} )
  # Discard entries that are incomplete or incorrectly formatted
  lines=( ${(M)lines:#/*\|[[:digit:]]##[.,]#[[:digit:]]#\|[[:digit:]]##} )

  ############################################################
  # Add a path to or remove one from the datafile
  #
  # Globals:
  #   ZSHZ
  #   ZSHZ_EXCLUDE_DIRS
  #   ZSHZ_OWNER
  #
  # Arguments:
  #   $1 Which action to perform (--add/--remove)
  #   $2 The path to add
  ############################################################
  _zshz_add_or_remove_path() {
    local action=${1}
    shift

    if [[ $action == '--add' ]]; then

      # TODO: The following tasks are now handled by _agkozak_precmd. Dead code?

      # Don't add $HOME
      [[ $* == $HOME ]] && return

      # Don't track directory trees excluded in ZSHZ_EXCLUDE_DIRS
      local exclude
      for exclude in ${(@)ZSHZ_EXCLUDE_DIRS:-${(@)_Z_EXCLUDE_DIRS}}; do
        case $* in
          ${exclude}|${exclude}/*) return ;;
        esac
      done
    fi

    # A temporary file that gets copied over the datafile if all goes well
    local tempfile="${datafile}.${RANDOM}"

    # See https://github.com/rupa/z/pull/199/commits/ed6eeed9b70d27c1582e3dd050e72ebfe246341c
    if (( ZSHZ[USE_FLOCK] )); then

      local lockfd

      # Grab exclusive lock (released when function exits)
      zsystem flock -f lockfd "$datafile" 2> /dev/null || return

    fi

    integer tmpfd
    case $action in
      --add)
        exec {tmpfd}>|"$tempfile"  # Open up tempfile for writing
        _zshz_update_datafile $tmpfd "$*"
        local ret=$?
        ;;
      --remove)
        local xdir  # Directory to be removed

        if (( ${ZSHZ_NO_RESOLVE_SYMLINKS:-${_Z_NO_RESOLVE_SYMLINKS}} )); then
          [[ -d ${${*:-${PWD}}:a} ]] && xdir=${${*:-${PWD}}:a}
        else
          [[ -d ${${*:-${PWD}}:A} ]] && xdir=${${*:-${PWD}}:a}
        fi

        local -a lines_to_keep
        if (( ${+opts[-R]} )); then
          # Prompt user before deleting entire database
          if [[ $xdir == '/' ]] && ! read -q "?Delete entire Zsh-z database? "; then
            print && return 1
          fi
          # All of the lines that don't match the directory to be deleted
          lines_to_keep=( ${lines:#${xdir}\|*} )
          # Or its subdirectories
          lines_to_keep=( ${lines_to_keep:#${xdir%/}/**} )
        else
          # All of the lines that don't match the directory to be deleted
          lines_to_keep=( ${lines:#${xdir}\|*} )
        fi
        if [[ $lines != "$lines_to_keep" ]]; then
          lines=( $lines_to_keep )
        else
          return 1  # The $PWD isn't in the datafile
        fi
        exec {tmpfd}>|"$tempfile"  # Open up tempfile for writing
        print -u $tmpfd -l -- $lines
        local ret=$?
        ;;
    esac

    if (( tmpfd != 0 )); then
      # Close tempfile
      exec {tmpfd}>&-
    fi

    if (( ret != 0 )); then
      # Avoid clobbering the datafile if the write to tempfile failed
      zf_rm -f "$tempfile"
      return $ret
    fi

    local owner
    owner=${ZSHZ_OWNER:-${_Z_OWNER}}

    if (( ZSHZ[USE_FLOCK] )); then
      zf_mv "$tempfile" "$datafile" 2> /dev/null || zf_rm -f "$tempfile"

      if [[ -n $owner ]]; then
        zf_chown ${owner}:"$(id -ng ${owner})" "$datafile"
      fi
    else
      if [[ -n $owner ]]; then
        zf_chown "${owner}":"$(id -ng "${owner}")" "$tempfile"
      fi
      zf_mv -f "$tempfile" "$datafile" 2> /dev/null || zf_rm -f "$tempfile"
    fi

    # In order to make z -x work, we have to disable zsh-z's adding
    # to the database until the user changes directory and the
    # chpwd_functions are run
    if [[ $action == '--remove' ]]; then
      ZSHZ[DIRECTORY_REMOVED]=1
    fi
  }

  ############################################################
  # Read the curent datafile contents, update them, "age" them
  # when the total rank gets high enough, and print the new
  # contents to STDOUT.
  #
  # Globals:
  #   ZSHZ_KEEP_DIRS
  #   ZSHZ_MAX_SCORE
  #
  # Arguments:
  #   $1 File descriptor linked to tempfile
  #   $2 Path to be added to datafile
  ############################################################
  _zshz_update_datafile() {

    integer fd=$1
    local -A rank time

    # Characters special to the shell (such as '[]') are quoted with backslashes
    # See https://github.com/rupa/z/issues/246
    local add_path=${(q)2}

    local -a existing_paths
    local now=$EPOCHSECONDS line dir
    local path_field rank_field time_field count x

    rank[$add_path]=1
    time[$add_path]=$now

    # Remove paths from database if they no longer exist
    for line in $lines; do
      if [[ ! -d ${line%%\|*} ]]; then
        for dir in ${(@)ZSHZ_KEEP_DIRS}; do
          if [[ ${line%%\|*} == ${dir}/* ||
                ${line%%\|*} == $dir     ||
                $dir == '/' ]]; then
            existing_paths+=( $line )
          fi
        done
      else
        existing_paths+=( $line )
      fi
    done
    lines=( $existing_paths )

    for line in $lines; do
      path_field=${(q)line%%\|*}
      rank_field=${${line%\|*}#*\|}
      time_field=${line##*\|}

      # When a rank drops below 1, drop the path from the database
      (( rank_field < 1 )) && continue

      if [[ $path_field == $add_path ]]; then
        rank[$path_field]=$rank_field
        (( rank[$path_field]++ ))
        time[$path_field]=$now
      else
        rank[$path_field]=$rank_field
        time[$path_field]=$time_field
      fi
      (( count += rank_field ))
    done
    if (( count > ${ZSHZ_MAX_SCORE:-${_Z_MAX_SCORE:-9000}} )); then
      # Aging
      for x in ${(k)rank}; do
        print -u $fd -- "$x|$(( 0.99 * rank[$x] ))|${time[$x]}" || return 1
      done
    else
      for x in ${(k)rank}; do
        print -u $fd -- "$x|${rank[$x]}|${time[$x]}" || return 1
      done
    fi
  }

  ############################################################
  # The original tab completion method
  #
  # String processing is smartcase -- case-insensitive if the
  # search string is lowercase, case-sensitive if there are
  # any uppercase letters. Spaces in the search string are
  # treated as *'s in globbing. Read the contents of the
  # datafile and print matches to STDOUT.
  #
  # Arguments:
  #   $1 The string to be completed
  ############################################################
  _zshz_legacy_complete() {

    local line path_field path_field_normalized

    # Replace spaces in the search string with asterisks for globbing
    1=${1//[[:space:]]/*}

    for line in $lines; do

      path_field=${line%%\|*}

      path_field_normalized=$path_field
      if (( ZSHZ_TRAILING_SLASH )); then
        path_field_normalized=${path_field%/}/
      fi

      # If the search string is all lowercase, the search will be case-insensitive
      if [[ $1 == "${1:l}" && ${path_field_normalized:l} == *${~1}* ]]; then
        print -- $path_field
      # Otherwise, case-sensitive
      elif [[ $path_field_normalized == *${~1}* ]]; then
        print -- $path_field
      fi

    done
    # TODO: Search strings with spaces in them are currently treated case-
    # insensitively.
  }

  ############################################################
  # `print' or `printf' to REPLY
  #
  # Variable assignment through command substitution, of the
  # form
  #
  #   foo=$( bar )
  #
  # requires forking a subshell; on Cygwin/MSYS2/WSL1 that can
  # be surprisingly slow. Zsh-z avoids doing that by printing
  # values to the variable REPLY. Since Zsh v5.3.0 that has
  # been possible with `print -v'; for earlier versions of the
  # shell, the values are placed on the editing buffer stack
  # and then `read' into REPLY.
  #
  # Globals:
  #   ZSHZ
  #
  # Arguments:
  #   Options and parameters for `print'
  ############################################################
  _zshz_printv() {
    # NOTE: For a long time, ZSH's `print -v' had a tendency
    # to mangle multibyte strings:
    #
    #   https://www.zsh.org/mla/workers/2020/msg00307.html
    #
    # The bug was fixed in late 2020:
    #
    #   https://github.com/zsh-users/zsh/commit/b6ba74cd4eaec2b6cb515748cf1b74a19133d4a4#diff-32bbef18e126b837c87b06f11bfc61fafdaa0ed99fcb009ec53f4767e246b129
    #
    # In order to support shells with the bug, we must use a form of `printf`,
    # which does not exhibit the undesired behavior. See
    #
    #   https://www.zsh.org/mla/workers/2020/msg00308.html

    if (( ZSHZ[PRINTV] )); then
      builtin print -v REPLY -f %s $@
    else
      builtin print -z $@
      builtin read -rz REPLY
    fi
  }

  ############################################################
  # If matches share a common root, find it, and put it in
  # REPLY for _zshz_output to use.
  #
  # Arguments:
  #   $1 Name of associative array of matches and ranks
  ############################################################
  _zshz_find_common_root() {
    local -a common_matches
    local x short

    common_matches=( ${(@Pk)1} )

    for x in ${(@)common_matches}; do
      if [[ -z $short ]] || (( $#x < $#short )) || [[ $x != ${short}/* ]]; then
        short=$x
      fi
    done

    [[ $short == '/' ]] && return

    for x in ${(@)common_matches}; do
      [[ $x != $short* ]] && return
    done

    _zshz_printv -- $short
  }

  ############################################################
  # Calculate a common root, if there is one. Then do one of
  # the following:
  #
  #   1) Print a list of completions in frecent order;
  #   2) List them (z -l) to STDOUT; or
  #   3) Put a common root or best match into REPLY
  #
  # Globals:
  #   ZSHZ_UNCOMMON
  #
  # Arguments:
  #   $1 Name of an associative array of matches and ranks
  #   $2 The best match or best case-insensitive match
  #   $3 Whether to produce a completion, a list, or a root or
  #        match
  ############################################################
  _zshz_output() {

    local match_array=$1 match=$2 format=$3
    local common k x
    local -a descending_list output
    local -A output_matches

    output_matches=( ${(Pkv)match_array} )

    _zshz_find_common_root $match_array
    common=$REPLY

    case $format in

      completion)
        for k in ${(@k)output_matches}; do
          _zshz_printv -f "%.2f|%s" ${output_matches[$k]} $k
          descending_list+=( ${(f)REPLY} )
          REPLY=''
        done
        descending_list=( ${${(@On)descending_list}#*\|} )
        print -l $descending_list
        ;;

      list)
        local path_to_display
        for x in ${(k)output_matches}; do
          if (( ${output_matches[$x]} )); then
            path_to_display=$x
            (( ZSHZ_TILDE )) &&
              path_to_display=${path_to_display/#${HOME}/\~}
            _zshz_printv -f "%-10d %s\n" ${output_matches[$x]} $path_to_display
            output+=( ${(f)REPLY} )
            REPLY=''
          fi
        done
        if [[ -n $common ]]; then
          (( ZSHZ_TILDE )) && common=${common/#${HOME}/\~}
          (( $#output > 1 )) && printf "%-10s %s\n" 'common:' $common
        fi
        # -lt
        if (( $+opts[-t] )); then
          for x in ${(@On)output}; do
            print -- $x
          done
        # -lr
        elif (( $+opts[-r] )); then
          for x in ${(@on)output}; do
            print -- $x
          done
        # -l
        else
          for x in ${(@on)output}; do
            print $x
          done
        fi
        ;;

      *)
        if (( ! ZSHZ_UNCOMMON )) && [[ -n $common ]]; then
          _zshz_printv -- $common
        else
          _zshz_printv -- ${(P)match}
        fi
        ;;
    esac
  }

  ############################################################
  # Match a pattern by rank, time, or a combination of the
  # two, and output the results as completions, a list, or a
  # best match.
  #
  # Globals:
  #   ZSHZ
  #   ZSHZ_CASE
  #   ZSHZ_KEEP_DIRS
  #   ZSHZ_OWNER
  #
  # Arguments:
  #   #1 Pattern to match
  #   $2 Matching method (rank, time, or [default] frecency)
  #   $3 Output format (completion, list, or [default] store
  #     in REPLY
  ############################################################
  _zshz_find_matches() {
    setopt LOCAL_OPTIONS NO_EXTENDED_GLOB

    local fnd=$1 method=$2 format=$3

    local -a existing_paths
    local line dir path_field rank_field time_field rank dx escaped_path_field
    local -A matches imatches
    local best_match ibest_match hi_rank=-9999999999 ihi_rank=-9999999999

    # Remove paths from database if they no longer exist
    for line in $lines; do
      if [[ ! -d ${line%%\|*} ]]; then
        for dir in ${(@)ZSHZ_KEEP_DIRS}; do
          if [[ ${line%%\|*} == ${dir}/* ||
                ${line%%\|*} == $dir     ||
                $dir == '/' ]]; then
            existing_paths+=( $line )
          fi
        done
      else
        existing_paths+=( $line )
      fi
    done
    lines=( $existing_paths )

    for line in $lines; do
      path_field=${line%%\|*}
      rank_field=${${line%\|*}#*\|}
      time_field=${line##*\|}

      case $method in
        rank) rank=$rank_field ;;
        time) (( rank = time_field - EPOCHSECONDS )) ;;
        *)
          # Frecency routine
          (( dx = EPOCHSECONDS - time_field ))
          rank=$(( 10000 * rank_field * (3.75/((0.0001 * dx + 1) + 0.25)) ))
          ;;
      esac

      # Use spaces as wildcards
      local q=${fnd//[[:space:]]/\*}

      # If $ZSHZ_TRAILING_SLASH is set, use path_field with a trailing slash for matching.
      local path_field_normalized=$path_field
      if (( ZSHZ_TRAILING_SLASH )); then
        path_field_normalized=${path_field%/}/
      fi

      # If $ZSHZ_CASE is 'ignore', be case-insensitive.
      #
      # If it's 'smart', be case-insensitive unless the string to be matched
      # includes capital letters.
      #
      # Otherwise, the default behavior of Zsh-z is to match case-sensitively if
      # possible, then to fall back on a case-insensitive match if possible.
      if [[ $ZSHZ_CASE == 'smart' && ${1:l} == $1 &&
            ${path_field_normalized:l} == ${~q:l} ]]; then
        imatches[$path_field]=$rank
      elif [[ $ZSHZ_CASE != 'ignore' && $path_field_normalized == ${~q} ]]; then
        matches[$path_field]=$rank
      elif [[ $ZSHZ_CASE != 'smart' && ${path_field_normalized:l} == ${~q:l} ]]; then
        imatches[$path_field]=$rank
      fi

      # Escape characters that would cause "invalid subscript" errors
      # when accessing the associative array.
      escaped_path_field=${path_field//'\'/'\\'}
      escaped_path_field=${escaped_path_field//'`'/'\`'}
      escaped_path_field=${escaped_path_field//'('/'\('}
      escaped_path_field=${escaped_path_field//')'/'\)'}
      escaped_path_field=${escaped_path_field//'['/'\['}
      escaped_path_field=${escaped_path_field//']'/'\]'}

      if (( matches[$escaped_path_field] )) &&
         (( matches[$escaped_path_field] > hi_rank )); then
        best_match=$path_field
        hi_rank=${matches[$escaped_path_field]}
      elif (( imatches[$escaped_path_field] )) &&
           (( imatches[$escaped_path_field] > ihi_rank )); then
        ibest_match=$path_field
        ihi_rank=${imatches[$escaped_path_field]}
        ZSHZ[CASE_INSENSITIVE]=1
      fi
    done

    # Return 1 when there are no matches
    [[ -z $best_match && -z $ibest_match ]] && return 1

    if [[ -n $best_match ]]; then
      _zshz_output matches best_match $format
    elif [[ -n $ibest_match ]]; then
      _zshz_output imatches ibest_match $format
    fi
  }

  # THE MAIN ROUTINE

  local -A opts

  zparseopts -E -D -A opts -- \
    -add \
    -complete \
    c \
    e \
    h \
    -help \
    l \
    r \
    R \
    t \
    x

  if [[ $1 == '--' ]]; then
    shift
  elif [[ -n ${(M)@:#-*} && -z $compstate ]]; then
    print "Improper option(s) given."
    _zshz_usage
    return 1
  fi

  local opt output_format method='frecency' fnd prefix req

  for opt in ${(k)opts}; do
    case $opt in
      --add)
        [[ ! -d $* ]] && return 1
        local dir
        # Cygwin and MSYS2 have a hard time with relative paths expressed from /
        if [[ $OSTYPE == (cygwin|msys) && $PWD == '/' && $* != /* ]]; then
          set -- "/$*"
        fi
        if (( ${ZSHZ_NO_RESOLVE_SYMLINKS:-${_Z_NO_RESOLVE_SYMLINKS}} )); then
          dir=${*:a}
        else
          dir=${*:A}
        fi
        _zshz_add_or_remove_path --add "$dir"
        return
        ;;
      --complete)
        if [[ -s $datafile && ${ZSHZ_COMPLETION:-frecent} == 'legacy' ]]; then
          _zshz_legacy_complete "$1"
          return
        fi
        output_format='completion'
        ;;
      -c) [[ $* == ${PWD}/* || $PWD == '/' ]] || prefix="$PWD " ;;
      -h|--help)
        _zshz_usage
        return
        ;;
      -l) output_format='list' ;;
      -r) method='rank' ;;
      -t) method='time' ;;
      -x)
        # Cygwin and MSYS2 have a hard time with relative paths expressed from /
        if [[ $OSTYPE == (cygwin|msys) && $PWD == '/' && $* != /* ]]; then
          set -- "/$*"
        fi
        _zshz_add_or_remove_path --remove $*
        return
        ;;
    esac
  done
  req="$*"
  fnd="$prefix$*"

  [[ -n $fnd && $fnd != "$PWD " ]] || {
    [[ $output_format != 'completion' ]] && output_format='list'
  }

  #########################################################
  # If $ZSHZ_ECHO == 1, display paths as you jump to them.
  # If it is also the case that $ZSHZ_TILDE == 1, display
  # the home directory as a tilde.
  #########################################################
  _zshz_echo() {
    if (( ZSHZ_ECHO )); then
      if (( ZSHZ_TILDE )); then
        print ${PWD/#${HOME}/\~}
      else
        print $PWD
      fi
    fi
  }

  if [[ ${@: -1} == /* ]] && (( ! $+opts[-e] && ! $+opts[-l] )); then
    # cd if possible; echo the new path if $ZSHZ_ECHO == 1
    [[ -d ${@: -1} ]] && builtin cd ${@: -1} && _zshz_echo && return
  fi

  # With option -c, make sure query string matches beginning of matches;
  # otherwise look for matches anywhere in paths

  # zpm-zsh/colors has a global $c, so we'll avoid math expressions here
  if [[ ! -z ${(tP)opts[-c]} ]]; then
    _zshz_find_matches "$fnd*" $method $output_format
  else
    _zshz_find_matches "*$fnd*" $method $output_format
  fi

  local ret2=$?

  local cd
  cd=$REPLY

  # New experimental "uncommon" behavior
  #
  # If the best choice at this point is something like /foo/bar/foo/bar, and the  # search pattern is `bar', go to /foo/bar/foo/bar; but if the search pattern
  # is `foo', go to /foo/bar/foo
  if (( ZSHZ_UNCOMMON )) && [[ -n $cd ]]; then
    if [[ -n $cd ]]; then

      # In the search pattern, replace spaces with *
      local q=${fnd//[[:space:]]/\*}
      q=${q%/} # Trailing slash has to be removed

      # As long as the best match is not case-insensitive
      if (( ! ZSHZ[CASE_INSENSITIVE] )); then
        # Count the number of characters in $cd that $q matches
        local q_chars=$(( ${#cd} - ${#${cd//${~q}/}} ))
        # Try dropping directory elements from the right; stop when it affects
        # how many times the search pattern appears
        until (( ( ${#cd:h} - ${#${${cd:h}//${~q}/}} ) != q_chars )); do
          cd=${cd:h}
        done

      # If the best match is case-insensitive
      else
        local q_chars=$(( ${#cd} - ${#${${cd:l}//${~${q:l}}/}} ))
        until (( ( ${#cd:h} - ${#${${${cd:h}:l}//${~${q:l}}/}} ) != q_chars )); do
          cd=${cd:h}
        done
      fi

      ZSHZ[CASE_INSENSITIVE]=0
    fi
  fi

  if (( ret2 == 0 )) && [[ -n $cd ]]; then
    if (( $+opts[-e] )); then               # echo
      (( ZSHZ_TILDE )) && cd=${cd/#${HOME}/\~}
      print -- "$cd"
    else
      # cd if possible; echo the new path if $ZSHZ_ECHO == 1
      [[ -d $cd ]] && builtin cd "$cd" && _zshz_echo
    fi
  else
    # if $req is a valid path, cd to it; echo the new path if $ZSHZ_ECHO == 1
    if ! (( $+opts[-e] || $+opts[-l] )) && [[ -d $req ]]; then
      builtin cd "$req" && _zshz_echo
    else
      return $ret2
    fi
  fi
}

alias ${ZSHZ_CMD:-${_Z_CMD:-z}}='zshz 2>&1'

############################################################
# precmd - add path to datafile unless `z -x' has just been
#   run
#
# Globals:
#   ZSHZ
############################################################
_zshz_precmd() {
  # Do not add PWD to datafile when in HOME directory, or
  # if `z -x' has just been run
  [[ $PWD == "$HOME" ]] || (( ZSHZ[DIRECTORY_REMOVED] )) && return

  # Don't track directory trees excluded in ZSHZ_EXCLUDE_DIRS
  local exclude
  for exclude in ${(@)ZSHZ_EXCLUDE_DIRS:-${(@)_Z_EXCLUDE_DIRS}}; do
    case $PWD in
      ${exclude}|${exclude}/*) return ;;
    esac
  done

  # It appears that forking a subshell is so slow in Windows that it is better
  # just to add the PWD to the datafile in the foreground
  if [[ $OSTYPE == (cygwin|msys) ]]; then
      zshz --add "$PWD"
  else
      (zshz --add "$PWD" &)
  fi

  # See https://github.com/rupa/z/pull/247/commits/081406117ea42ccb8d159f7630cfc7658db054b6
  : $RANDOM
}

############################################################
# chpwd
#
# When the $PWD is removed from the datafile with `z -x',
# Zsh-z refrains from adding it again until the user has
# left the directory.
#
# Globals:
#   ZSHZ
############################################################
_zshz_chpwd() {
  ZSHZ[DIRECTORY_REMOVED]=0
}

autoload -Uz add-zsh-hook

add-zsh-hook precmd _zshz_precmd
add-zsh-hook chpwd _zshz_chpwd

############################################################
# Completion
############################################################

# Standarized $0 handling
# (See https://github.com/agkozak/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc)
0=${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}
0=${${(M)0:#/*}:-$PWD/$0}

(( ${fpath[(ie)${0:A:h}]} <= ${#fpath} )) || fpath=( "${0:A:h}" "${fpath[@]}" )

############################################################
# zsh-z functions
############################################################
ZSHZ[FUNCTIONS]='_zshz_usage
                 _zshz_add_or_remove_path
                 _zshz_update_datafile
                 _zshz_legacy_complete
                 _zshz_printv
                 _zshz_find_common_root
                 _zshz_output
                 _zshz_find_matches
                 zshz
                 _zshz_precmd
                 _zshz_chpwd
                 _zshz'

############################################################
# Enable WARN_NESTED_VAR for functions listed in
#   ZSHZ[FUNCTIONS]
############################################################
(( ZSHZ_DEBUG )) && () {
  if is-at-least 5.4.0; then
    local x
    for x in ${=ZSHZ[FUNCTIONS]}; do
      functions -W $x
    done
  fi
}

############################################################
# Unload function
#
# See https://github.com/agkozak/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc#unload-fun
#
# Globals:
#   ZSHZ
#   ZSHZ_CMD
############################################################
zsh-z_plugin_unload() {
  emulate -L zsh

  add-zsh-hook -D precmd _zshz_precmd
  add-zsh-hook -d chpwd _zshz_chpwd

  local x
  for x in ${=ZSHZ[FUNCTIONS]}; do
    (( ${+functions[$x]} )) && unfunction $x
  done

  unset ZSHZ

  fpath=( "${(@)fpath:#${0:A:h}}" )

  (( ${+aliases[${ZSHZ_CMD:-${_Z_CMD:-z}}]} )) &&
    unalias ${ZSHZ_CMD:-${_Z_CMD:-z}}

  unfunction $0
}

# vim: fdm=indent:ts=2:et:sts=2:sw=2:
