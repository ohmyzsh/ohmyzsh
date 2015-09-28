#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2015 zsh-syntax-highlighting contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this list of conditions
#    and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of
#    conditions and the following disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of the zsh-syntax-highlighting contributors nor the names of its contributors
#    may be used to endorse or promote products derived from this software without specific prior
#    written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------


# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[default]:=none}
: ${ZSH_HIGHLIGHT_STYLES[unknown-token]:=fg=red,bold}
: ${ZSH_HIGHLIGHT_STYLES[reserved-word]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[alias]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[suffix-alias]:=fg=green,underline}
: ${ZSH_HIGHLIGHT_STYLES[builtin]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[function]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[command]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[precommand]:=fg=green,underline}
: ${ZSH_HIGHLIGHT_STYLES[commandseparator]:=none}
: ${ZSH_HIGHLIGHT_STYLES[hashed-command]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[path]:=underline}
: ${ZSH_HIGHLIGHT_STYLES[path_prefix]:=underline}
: ${ZSH_HIGHLIGHT_STYLES[path_approx]:=fg=yellow,underline}
: ${ZSH_HIGHLIGHT_STYLES[globbing]:=fg=blue}
: ${ZSH_HIGHLIGHT_STYLES[history-expansion]:=fg=blue}
: ${ZSH_HIGHLIGHT_STYLES[single-hyphen-option]:=none}
: ${ZSH_HIGHLIGHT_STYLES[double-hyphen-option]:=none}
: ${ZSH_HIGHLIGHT_STYLES[back-quoted-argument]:=none}
: ${ZSH_HIGHLIGHT_STYLES[single-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[double-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[assign]:=none}
: ${ZSH_HIGHLIGHT_STYLES[redirection]:=none}

# Whether the highlighter should be called or not.
_zsh_highlight_main_highlighter_predicate()
{
  _zsh_highlight_buffer_modified
}

# Helper to deal with tokens crossing line boundaries.
_zsh_highlight_main_add_region_highlight() {
  integer start=$1 end=$2
  local style=$3

  # The calculation was relative to $PREBUFFER$BUFFER, but region_highlight is
  # relative to $BUFFER.
  (( start -= $#PREBUFFER ))
  (( end -= $#PREBUFFER ))

  (( end < 0 )) && return # having end<0 would be a bug
  (( start < 0 )) && start=0 # having start<0 is normal with e.g. multiline strings
  region_highlight+=("$start $end $style")
}

# Main syntax highlighting function.
_zsh_highlight_main_highlighter()
{
  emulate -L zsh
  setopt localoptions extendedglob bareglobqual
  local start_pos=0 end_pos highlight_glob=true new_expression=true arg style sudo=false sudo_arg=false
  local redirection=false # true when we've seen a redirection operator before seeing the command word
  typeset -a ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR
  typeset -a ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS
  typeset -a ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS
  local buf="$PREBUFFER$BUFFER"
  region_highlight=()

  ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR=(
    '|' '||' ';' '&' '&&'
  )
  ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS=(
    'builtin' 'command' 'exec' 'nocorrect' 'noglob'
  )
  # Tokens that are always immediately followed by a command.
  ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS=(
    $ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR $ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS
  )

  for arg in ${(z)buf}; do
    # substr_color is set to 1 to disable adding an entry to region_highlight
    # for this iteration.  Currently, that is done for "" and $'' strings,
    # which add the entry early so escape sequences within the string override
    # the string's color.
    integer substr_color=0
    local style_override=""
    if $new_expression && [[ $arg = 'noglob' ]]; then
      highlight_glob=false
    fi

    # advance $start_pos, skipping over whitespace in $buf.
    if [[ $arg == ';' ]] ; then
      # We're looking for either a semicolon or a newline, whichever comes
      # first.  Both of these are rendered as a ";" (SEPER) by the ${(z)..}
      # flag.
      #
      # We can't use the (Z+n+) flag because that elides the end-of-command
      # token altogether, so 'echo foo\necho bar' (two commands) becomes
      # indistinguishable from 'echo foo echo bar' (one command with three
      # words for arguments).
      local needle=$'[;\n]'
      integer offset=${${buf[start_pos+1,-1]}[(i)$needle]}
      (( start_pos += offset - 1 ))
      (( end_pos = start_pos + $#arg ))
    else
      ((start_pos+=${#buf[$start_pos+1,-1]}-${#${buf[$start_pos+1,-1]##([[:space:]]|\\[[:space:]])#}}))
      ((end_pos=$start_pos+${#arg}))
    fi

    # Parse the sudo command line
    if $sudo; then
      case "$arg" in
        # Flag that requires an argument
        '-'[Cgprtu]) sudo_arg=true;;
        # This prevents misbehavior with sudo -u -otherargument
        '-'*)        sudo_arg=false;;
        *)           if $sudo_arg; then
                       sudo_arg=false
                     else
                       sudo=false
                       new_expression=true; highlight_glob=true
                     fi
                     ;;
      esac
    fi
    if $new_expression && ! $redirection; then # $arg is the command word
      new_expression=false
     if [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS:#"$arg"} ]]; then
      style=$ZSH_HIGHLIGHT_STYLES[precommand]
     elif [[ "$arg" = "sudo" ]]; then
      style=$ZSH_HIGHLIGHT_STYLES[precommand]
      sudo=true
     else
      local res="$(LC_ALL=C builtin type -w ${(Q)arg} 2>/dev/null)"
      case $res in
        *': reserved')  style=$ZSH_HIGHLIGHT_STYLES[reserved-word];;
        *': suffix alias')
                        style=$ZSH_HIGHLIGHT_STYLES[suffix-alias]
                        ;;
        *': alias')     style=$ZSH_HIGHLIGHT_STYLES[alias]
                        local aliased_command="${"$(alias -- $arg)"#*=}"
                        [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$aliased_command"} && -z ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$arg"} ]] && ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS+=($arg)
                        ;;
        *': builtin')   style=$ZSH_HIGHLIGHT_STYLES[builtin];;
        *': function')  style=$ZSH_HIGHLIGHT_STYLES[function];;
        *': command')   style=$ZSH_HIGHLIGHT_STYLES[command];;
        *': hashed')    style=$ZSH_HIGHLIGHT_STYLES[hashed-command];;
        *)              if _zsh_highlight_main_highlighter_check_assign; then
                          style=$ZSH_HIGHLIGHT_STYLES[assign]
                          if [[ $arg[-1] != '(' ]]; then
                            # assignment to a scalar parameter.
                            # (For array assignments, the command doesn't start until the ")" token.)
                            new_expression=true; highlight_glob=true
                          fi
                        elif [[ $arg[0,1] == $histchars[0,1] || $arg[0,1] == $histchars[2,2] ]]; then
                          style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                        elif [[ $arg[1] == '<' || $arg[1] == '>' ]]; then
                          style=$ZSH_HIGHLIGHT_STYLES[redirection]
                          redirection=true
                        elif [[ $arg[1,2] == '((' ]]; then
                          # Arithmetic evaluation.
                          #
                          # Note: prior to zsh-5.1.1-52-g4bed2cf (workers/36669), the ${(z)...}
                          # splitter would only output the '((' token if the matching '))' had
                          # been typed.  Therefore, under those versions of zsh, BUFFER="(( 42"
                          # would be highlighted as an error until the matching "))" are typed.
                          #
                          # We highlight just the opening parentheses, as a reserved word; this
                          # is how [[ ... ]] is highlighted, too.
                          style=$ZSH_HIGHLIGHT_STYLES[reserved-word]
                          _zsh_highlight_main_add_region_highlight $start_pos $((start_pos + 2)) $style
                          substr_color=1
                        else
                          if _zsh_highlight_main_highlighter_check_path; then
                            style=$ZSH_HIGHLIGHT_STYLES[path]
                          else
                            style=$ZSH_HIGHLIGHT_STYLES[unknown-token]
                          fi
                        fi
                        ;;
      esac
     fi
    else # $arg is the file target of a prefix redirection, or a non-command word
      if $redirection; then
        redirection=false
        new_expression=true; highlight_glob=true
      fi
      case $arg in
        '--'*)   style=$ZSH_HIGHLIGHT_STYLES[double-hyphen-option];;
        '-'*)    style=$ZSH_HIGHLIGHT_STYLES[single-hyphen-option];;
        "'"*)    style=$ZSH_HIGHLIGHT_STYLES[single-quoted-argument];;
        '"'*)    style=$ZSH_HIGHLIGHT_STYLES[double-quoted-argument]
                 _zsh_highlight_main_add_region_highlight $start_pos $end_pos $style
                 _zsh_highlight_main_highlighter_highlight_string
                 substr_color=1
                 ;;
        \$\'*)   style=$ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]
                 _zsh_highlight_main_add_region_highlight $start_pos $end_pos $style
                 _zsh_highlight_main_highlighter_highlight_dollar_string
                 substr_color=1
                 ;;
        '`'*)    style=$ZSH_HIGHLIGHT_STYLES[back-quoted-argument];;
        *[*?]*)  $highlight_glob && style=$ZSH_HIGHLIGHT_STYLES[globbing] || style=$ZSH_HIGHLIGHT_STYLES[default];;
        *)       if false; then
                 elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                 elif [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR:#"$arg"} ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[commandseparator]
                 elif [[ $arg[1] == '<' || $arg[1] == '>' ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[redirection]
                 else
                   if _zsh_highlight_main_highlighter_check_path; then
                     style=$ZSH_HIGHLIGHT_STYLES[path]
                   else
                     style=$ZSH_HIGHLIGHT_STYLES[default]
                   fi
                 fi
                 ;;
      esac
    fi
    # if a style_override was set (eg in _zsh_highlight_main_highlighter_check_path), use it
    [[ -n $style_override ]] && style=$ZSH_HIGHLIGHT_STYLES[$style_override]
    [[ $substr_color = 0 ]] && _zsh_highlight_main_add_region_highlight $start_pos $end_pos $style
    [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$arg"} ]] && new_expression=true
    [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR:#"$arg"} ]] && highlight_glob=true
    start_pos=$end_pos
  done
}

# Check if the argument is variable assignment
_zsh_highlight_main_highlighter_check_assign()
{
    setopt localoptions extended_glob
    [[ $arg == [[:alpha:]_][[:alnum:]_]#(|\[*\])(|[+])=* ]]
}

# Check if the argument is a path.
_zsh_highlight_main_highlighter_check_path()
{
  setopt localoptions nonomatch
  local expanded_path; : ${expanded_path:=${(Q)~arg}}
  [[ -z $expanded_path ]] && return 1
  [[ -e $expanded_path ]] && return 0
  # Search the path in CDPATH
  local cdpath_dir
  for cdpath_dir in $cdpath ; do
    [[ -e "$cdpath_dir/$expanded_path" ]] && return 0
  done
  [[ ! -e ${expanded_path:h} ]] && return 1
  if [[ ${BUFFER[1]} != "-" && ${#BUFFER} == $end_pos ]]; then
    local -a tmp
    # got a path prefix?
    tmp=( ${expanded_path}*(N) )
    (( $#tmp > 0 )) && style_override=path_prefix && return 0
    # or maybe an approximate path?
    tmp=( (#a1)${expanded_path}*(N) )
    (( $#tmp > 0 )) && style_override=path_approx && return 0
  fi
  return 1
}

# Highlight special chars inside double-quoted strings
_zsh_highlight_main_highlighter_highlight_string()
{
  setopt localoptions noksharrays
  local i j k style
  # Starting quote is at 1, so start parsing at offset 2 in the string.
  for (( i = 2 ; i < end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      '$' ) style=$ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]
            # Look for an alphanumeric parameter name.
            if [[ ${arg:$i} =~ ^([A-Za-z_][A-Za-z0-9_]*|[0-9]+) ]] ; then
              (( k += $#MATCH )) # highlight the parameter name
              (( i += $#MATCH )) # skip past it
            else
              continue
            fi
            ;;
      "\\") style=$ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]
            if [[ \\\`\"\$ == *$arg[$i+1]* ]]; then
              (( k += 1 )) # Color following char too.
              (( i += 1 )) # Skip parsing the escaped char.
            else
              continue
            fi
            ;;
      *) continue ;;

    esac
    _zsh_highlight_main_add_region_highlight $j $k $style
  done
}

# Highlight special chars inside dollar-quoted strings
_zsh_highlight_main_highlighter_highlight_dollar_string()
{
  setopt localoptions noksharrays
  local i j k style
  local AA
  integer c
  # Starting dollar-quote is at 1:2, so start parsing at offset 3 in the string.
  for (( i = 3 ; i < end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      "\\") style=$ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]
            for (( c = i + 1 ; c <= end_pos - start_pos ; c += 1 )); do
              [[ "$arg[$c]" != ([0-9xXuUa-fA-F]) ]] && break
            done
            AA=$arg[$i+1,$c-1]
            # Matching for HEX and OCT values like \0xA6, \xA6 or \012
            if [[    "$AA" =~ "^(x|X)[0-9a-fA-F]{1,2}"
                  || "$AA" =~ "^[0-7]{1,3}"
                  || "$AA" =~ "^u[0-9a-fA-F]{1,4}"
                  || "$AA" =~ "^U[0-9a-fA-F]{1,8}"
               ]]; then
              (( k += $#MATCH ))
              (( i += $#MATCH ))
            else
              if (( $#arg > $i+1 )) && [[ $arg[$i+1] == [xXuU] ]]; then
                # \x not followed by hex digits is probably an error
                style=$ZSH_HIGHLIGHT_STYLES[unknown-token]
              fi
              (( k += 1 )) # Color following char too.
              (( i += 1 )) # Skip parsing the escaped char.
            fi
            ;;
      *) continue ;;

    esac
    _zsh_highlight_main_add_region_highlight $j $k $style
  done
}
