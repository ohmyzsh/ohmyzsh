# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2020 zsh-syntax-highlighting contributors
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
: ${ZSH_HIGHLIGHT_STYLES[suffix-alias]:=fg=green,underline}
: ${ZSH_HIGHLIGHT_STYLES[global-alias]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[precommand]:=fg=green,underline}
: ${ZSH_HIGHLIGHT_STYLES[commandseparator]:=none}
: ${ZSH_HIGHLIGHT_STYLES[autodirectory]:=fg=green,underline}
: ${ZSH_HIGHLIGHT_STYLES[path]:=underline}
: ${ZSH_HIGHLIGHT_STYLES[path_pathseparator]:=}
: ${ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]:=}
: ${ZSH_HIGHLIGHT_STYLES[globbing]:=fg=blue}
: ${ZSH_HIGHLIGHT_STYLES[history-expansion]:=fg=blue}
: ${ZSH_HIGHLIGHT_STYLES[command-substitution]:=none}
: ${ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]:=fg=magenta}
: ${ZSH_HIGHLIGHT_STYLES[process-substitution]:=none}
: ${ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]:=fg=magenta}
: ${ZSH_HIGHLIGHT_STYLES[single-hyphen-option]:=none}
: ${ZSH_HIGHLIGHT_STYLES[double-hyphen-option]:=none}
: ${ZSH_HIGHLIGHT_STYLES[back-quoted-argument]:=none}
: ${ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]:=fg=magenta}
: ${ZSH_HIGHLIGHT_STYLES[single-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[double-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[rc-quote]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[assign]:=none}
: ${ZSH_HIGHLIGHT_STYLES[redirection]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[comment]:=fg=black,bold}
: ${ZSH_HIGHLIGHT_STYLES[named-fd]:=none}
: ${ZSH_HIGHLIGHT_STYLES[numeric-fd]:=none}
: ${ZSH_HIGHLIGHT_STYLES[arg0]:=fg=green}

# Whether the highlighter should be called or not.
_zsh_highlight_highlighter_main_predicate()
{
  # may need to remove path_prefix highlighting when the line ends
  [[ $WIDGET == zle-line-finish ]] || _zsh_highlight_buffer_modified
}

# Helper to deal with tokens crossing line boundaries.
_zsh_highlight_main_add_region_highlight() {
  integer start=$1 end=$2
  shift 2

  if (( $#in_alias )); then
    [[ $1 == unknown-token ]] && alias_style=unknown-token
    return
  fi
  if (( in_param )); then
    if [[ $1 == unknown-token ]]; then
      param_style=unknown-token
    fi
    if [[ -n $param_style ]]; then
      return
    fi
    param_style=$1
    return
  fi

  # The calculation was relative to $buf but region_highlight is relative to $BUFFER.
  (( start += buf_offset ))
  (( end += buf_offset ))

  list_highlights+=($start $end $1)
}

_zsh_highlight_main_add_many_region_highlights() {
  for 1 2 3; do
    _zsh_highlight_main_add_region_highlight $1 $2 $3
  done
}

_zsh_highlight_main_calculate_fallback() {
  local -A fallback_of; fallback_of=(
      alias arg0
      suffix-alias arg0
      global-alias dollar-double-quoted-argument
      builtin arg0
      function arg0
      command arg0
      precommand arg0
      hashed-command arg0
      autodirectory arg0
      arg0_\* arg0

      # TODO: Maybe these? —
      #   named-fd file-descriptor
      #   numeric-fd file-descriptor

      path_prefix path
      # The path separator fallback won't ever be used, due to the optimisation
      # in _zsh_highlight_main_highlighter_highlight_path_separators().
      path_pathseparator path
      path_prefix_pathseparator path_prefix

      single-quoted-argument{-unclosed,}
      double-quoted-argument{-unclosed,}
      dollar-quoted-argument{-unclosed,}
      back-quoted-argument{-unclosed,}

      command-substitution{-quoted,,-unquoted,}
      command-substitution-delimiter{-quoted,,-unquoted,}

      command-substitution{-delimiter,}
      process-substitution{-delimiter,}
      back-quoted-argument{-delimiter,}
  )
  local needle=$1 value
  reply=($1)
  while [[ -n ${value::=$fallback_of[(k)$needle]} ]]; do
    unset "fallback_of[$needle]" # paranoia against infinite loops
    reply+=($value)
    needle=$value
  done
}

# Get the type of a command.
#
# Uses the zsh/parameter module if available to avoid forks, and a
# wrapper around 'type -w' as fallback.
#
# If $2 is 0, do not consider aliases.
#
# The result will be stored in REPLY.
_zsh_highlight_main__type() {
  integer -r aliases_allowed=${2-1}
  # We won't cache replies of anything that exists as an alias at all, to
  # ensure the cached value is correct regardless of $aliases_allowed.
  #
  # ### We probably _should_ cache them in a cache that's keyed on the value of
  # ### $aliases_allowed, on the assumption that aliases are the common case.
  integer may_cache=1

  # Cache lookup
  if (( $+_zsh_highlight_main__command_type_cache )); then
    REPLY=$_zsh_highlight_main__command_type_cache[(e)$1]
    if [[ -n "$REPLY" ]]; then
      return
    fi
  fi

  # Main logic
  if (( $#options_to_set )); then
    setopt localoptions $options_to_set;
  fi
  unset REPLY
  if zmodload -e zsh/parameter; then
    if (( $+aliases[(e)$1] )); then
      may_cache=0
    fi
    if (( ${+galiases[(e)$1]} )) && (( aliases_allowed )); then
      REPLY='global alias'
    elif (( $+aliases[(e)$1] )) && (( aliases_allowed )); then
      REPLY=alias
    elif [[ $1 == *.* && -n ${1%.*} ]] && (( $+saliases[(e)${1##*.}] )); then
      REPLY='suffix alias'
    elif (( $reswords[(Ie)$1] )); then
      REPLY=reserved
    elif (( $+functions[(e)$1] )); then
      REPLY=function
    elif (( $+builtins[(e)$1] )); then
      REPLY=builtin
    elif (( $+commands[(e)$1] )); then
      REPLY=command
    # None of the special hashes had a match, so fall back to 'type -w', for
    # forward compatibility with future versions of zsh that may add new command
    # types.
    #
    # zsh 5.2 and older have a bug whereby running 'type -w ./sudo' implicitly
    # runs 'hash ./sudo=/usr/local/bin/./sudo' (assuming /usr/local/bin/sudo
    # exists and is in $PATH).  Avoid triggering the bug, at the expense of
    # falling through to the $() below, incurring a fork.  (Issue #354.)
    #
    # The first disjunct mimics the isrelative() C call from the zsh bug.
    elif {  [[ $1 != */* ]] || is-at-least 5.3 } &&
         # Add a subshell to avoid a zsh upstream bug; see issue #606.
         # ### Remove the subshell when we stop supporting zsh 5.7.1 (I assume 5.8 will have the bugfix).
         ! (builtin type -w -- "$1") >/dev/null 2>&1; then
      REPLY=none
    fi
  fi
  if ! (( $+REPLY )); then
    # zsh/parameter not available or had no matches.
    #
    # Note that 'type -w' will run 'rehash' implicitly.
    #
    # We 'unalias' in a subshell, so the parent shell is not affected.
    #
    # The colon command is there just to avoid a command substitution that
    # starts with an arithmetic expression [«((…))» as the first thing inside
    # «$(…)»], which is area that has had some parsing bugs before 5.6
    # (approximately).
    REPLY="${$(:; (( aliases_allowed )) || unalias -- "$1" 2>/dev/null; LC_ALL=C builtin type -w -- "$1" 2>/dev/null)##*: }"
    if [[ $REPLY == 'alias' ]]; then
      may_cache=0
    fi
  fi

  # Cache population
  if (( may_cache )) && (( $+_zsh_highlight_main__command_type_cache )); then
    _zsh_highlight_main__command_type_cache[(e)$1]=$REPLY
  fi
  [[ -n $REPLY ]]
  return $?
}

# Checks whether $1 is something that can be run.
#
# Return 0 if runnable, 1 if not runnable, 2 if trouble.
_zsh_highlight_main__is_runnable() {
  if _zsh_highlight_main__type "$1"; then
    [[ $REPLY != none ]]
  else
    return 2
  fi
}

# Check whether the first argument is a redirection operator token.
# Report result via the exit code.
_zsh_highlight_main__is_redirection() {
  # A redirection operator token:
  # - starts with an optional single-digit number;
  # - then, has a '<' or '>' character;
  # - is not a process substitution [<(...) or >(...)].
  # - is not a numeric glob <->
  [[ $1 == (<0-9>|)(\<|\>)* ]] && [[ $1 != (\<|\>)$'\x28'* ]] && [[ $1 != *'<'*'-'*'>'* ]]
}

# Resolve alias.
#
# Takes a single argument.
#
# The result will be stored in REPLY.
_zsh_highlight_main__resolve_alias() {
  if zmodload -e zsh/parameter; then
    REPLY=${aliases[$arg]}
  else
    REPLY="${"$(alias -- $arg)"#*=}"
  fi
}

# Return true iff $1 is a global alias
_zsh_highlight_main__is_global_alias() {
  if zmodload -e zsh/parameter; then
    (( ${+galiases[$arg]} ))
  elif [[ $arg == '='* ]]; then
    # avoid running into «alias -L '=foo'» erroring out with 'bad assignment'
    return 1
  else
    alias -L -g -- "$1" >/dev/null
  fi
}

# Check that the top of $braces_stack has the expected value.  If it does, set
# the style according to $2; otherwise, set style=unknown-token.
#
# $1: character expected to be at the top of $braces_stack
# $2: optional assignment to style it if matches
# return value is 0 if there is a match else 1
_zsh_highlight_main__stack_pop() {
  if [[ $braces_stack[1] == $1 ]]; then
    braces_stack=${braces_stack:1}
    if (( $+2 )); then
      style=$2
    fi
    return 0
  else
    style=unknown-token
    return 1
  fi
}

# Main syntax highlighting function.
_zsh_highlight_highlighter_main_paint()
{
  setopt localoptions extendedglob

  # At the PS3 prompt and in vared, highlight nothing.
  #
  # (We can't check this in _zsh_highlight_highlighter_main_predicate because
  # if the predicate returns false, the previous value of region_highlight
  # would be reused.)
  if [[ $CONTEXT == (select|vared) ]]; then
    return
  fi

  typeset -a ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR
  typeset -a ZSH_HIGHLIGHT_TOKENS_CONTROL_FLOW
  local -a options_to_set reply # used in callees
  local REPLY

  # $flags_with_argument is a set of letters, corresponding to the option letters
  # that would be followed by a colon in a getopts specification.
  local flags_with_argument
  # $flags_sans_argument is a set of letters, corresponding to the option letters
  # that wouldn't be followed by a colon in a getopts specification.
  local flags_sans_argument
  # $flags_solo is a set of letters, corresponding to option letters that, if
  # present, mean the precommand will not be acting as a precommand, i.e., will
  # not be followed by a :start: word.
  local flags_solo
  # $precommand_options maps precommand name to values of $flags_with_argument,
  # $flags_sans_argument, and flags_solo for that precommand, joined by a
  # colon.  (The value is NOT a getopt(3) spec, although it resembles one.)
  #
  # Currently, setting $flags_sans_argument is only important for commands that
  # have a non-empty $flags_with_argument; see test-data/precommand4.zsh.
  local -A precommand_options
  precommand_options=(
    # Precommand modifiers as of zsh 5.6.2 cf. zshmisc(1).
    '-' ''
    'builtin' ''
    'command' :pvV
    'exec' a:cl
    'noglob' ''
    # 'time' and 'nocorrect' shouldn't be added here; they're reserved words, not precommands.

    # miscellaneous commands
    'doas' aCu:Lns # as of OpenBSD's doas(1) dated September 4, 2016
    'nice' n: # as of current POSIX spec
    'pkexec' '' # doesn't take short options; immune to #121 because it's usually not passed --option flags
    # Not listed: -h, which has two different meanings.
    'sudo' Cgprtu:AEHPSbilns:eKkVv # as of sudo 1.8.21p2
    'stdbuf' ioe:
    'eatmydata' ''
    'catchsegv' ''
    'nohup' ''
    'setsid' :wc
    'env' u:i
    'ionice' cn:t:pPu # util-linux 2.33.1-0.1
    'strace' IbeaosXPpEuOS:ACdfhikqrtTvVxyDc # strace 4.26-0.2
    'proxychains' q:f # proxychains 4.4.0
    'torsocks' idq:upaP # Torsocks 2.3.0
    'torify' idq:upaP # Torsocks 2.3.0
    'ssh-agent' aEPt:csDd:k # As of OpenSSH 8.1p1
    'tabbed' gnprtTuU:cdfhs:v # suckless-tools v44
    'chronic' :ev # moreutils 0.62-1
    'ifne' :n # moreutils 0.62-1
    'grc' :se # grc - a "generic colouriser" (that's their spelling, not mine)
    'cpulimit' elp:ivz # cpulimit 0.2
  )
  # Commands that would need to skip one positional argument:
  #    flock
  #    ssh
  #    _wanted (skip two)

  if [[ $zsyh_user_options[ignorebraces] == on || ${zsyh_user_options[ignoreclosebraces]:-off} == on ]]; then
    local right_brace_is_recognised_everywhere=false
  else
    local right_brace_is_recognised_everywhere=true
  fi

  if [[ $zsyh_user_options[pathdirs] == on ]]; then
    options_to_set+=( PATH_DIRS )
  fi

  ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR=(
    '|' '||' ';' '&' '&&'
    $'\n' # ${(z)} returns ';' but we convert it to $'\n'
    '|&'
    '&!' '&|'
    # ### 'case' syntax, but followed by a pattern, not by a command
    # ';;' ';&' ';|'
  )

  # Tokens that, at (naively-determined) "command position", are followed by
  # a de jure command position.  All of these are reserved words.
  ZSH_HIGHLIGHT_TOKENS_CONTROL_FLOW=(
    $'\x7b' # block
    $'\x28' # subshell
    '()' # anonymous function
    'while'
    'until'
    'if'
    'then'
    'elif'
    'else'
    'do'
    'time'
    'coproc'
    '!' # reserved word; unrelated to $histchars[1]
  )

  if (( $+X_ZSH_HIGHLIGHT_DIRS_BLACKLIST )); then
    print >&2 'zsh-syntax-highlighting: X_ZSH_HIGHLIGHT_DIRS_BLACKLIST is deprecated. Please use ZSH_HIGHLIGHT_DIRS_BLACKLIST.'
    ZSH_HIGHLIGHT_DIRS_BLACKLIST=($X_ZSH_HIGHLIGHT_DIRS_BLACKLIST)
    unset X_ZSH_HIGHLIGHT_DIRS_BLACKLIST
  fi

  _zsh_highlight_main_highlighter_highlight_list -$#PREBUFFER '' 1 "$PREBUFFER$BUFFER"

  # end is a reserved word
  local start end_ style
  for start end_ style in $reply; do
    (( start >= end_ )) && { print -r -- >&2 "zsh-syntax-highlighting: BUG: _zsh_highlight_highlighter_main_paint: start($start) >= end($end_)"; return }
    (( end_ <= 0 )) && continue
    (( start < 0 )) && start=0 # having start<0 is normal with e.g. multiline strings
    _zsh_highlight_main_calculate_fallback $style
    _zsh_highlight_add_highlight $start $end_ $reply
  done
}

# Try to expand $1, if it's possible to do so safely.
# 
# Uses two parameters from the caller: $parameter_name_pattern and $res.
#
# If expansion was done, set $reply to the expansion and return true.
# Otherwise, return false.
_zsh_highlight_main_highlighter__try_expand_parameter()
{
  local arg="$1"
  unset reply
  {
    # ### For now, expand just '$foo' or '${foo}', possibly with braces, but with
    # ### no other features of the parameter expansion syntax.  (No ${(x)foo},
    # ### no ${foo[x]}, no ${foo:-x}.)
    {
      local -a match mbegin mend
      local MATCH; integer MBEGIN MEND
      local parameter_name
      local -a words
      if [[ $arg[1] != '$' ]]; then
        return 1
      fi
      if [[ ${arg[2]} == '{' ]] && [[ ${arg[-1]} == '}' ]]; then
        parameter_name=${${arg:2}%?}
      else
        parameter_name=${arg:1}
      fi
      if [[ $res == none ]] && 
         [[ ${parameter_name} =~ ^${~parameter_name_pattern}$ ]] &&
         [[ ${(tP)MATCH} != *special* ]]
      then
        # Set $arg and update $res.
        case ${(tP)MATCH} in
          (*array*|*assoc*)
            words=( ${(P)MATCH} )
            ;;
          ("")
            # not set
            words=( )
            ;;
          (*)
            # scalar, presumably
            if [[ $zsyh_user_options[shwordsplit] == on ]]; then
              words=( ${(P)=MATCH} )
            else
              words=( ${(P)MATCH} )
            fi
            ;;
        esac
        reply=( "${words[@]}" )
      else
        return 1
      fi
    }
  }
}

# $1 is the offset of $4 from the parent buffer. Added to the returned highlights.
# $2 is the initial braces_stack (for a closing paren).
# $3 is 1 if $4 contains the end of $BUFFER, else 0.
# $4 is the buffer to highlight.
# Returns:
# $REPLY: $buf[REPLY] is the last character parsed.
# $reply is an array of region_highlight additions.
# exit code is 0 if the braces_stack is empty, 1 otherwise.
_zsh_highlight_main_highlighter_highlight_list()
{
  integer start_pos end_pos=0 buf_offset=$1 has_end=$3
  # alias_style is the style to apply to an alias once $#in_alias == 0
  #     Usually 'alias' but set to 'unknown-token' if any word expanded from
  #     the alias would be highlighted as unknown-token
  # param_style is analogous for parameter expansions
  local alias_style param_style last_arg arg buf=$4 highlight_glob=true saw_assignment=false style
  local in_array_assignment=false # true between 'a=(' and the matching ')'
  # in_alias is an array of integers with each element equal to the number
  #     of shifts needed until arg=args[1] pops an arg from the next level up
  #     alias or from BUFFER.
  # in_param is analogous for parameter expansions
  integer in_param=0 len=$#buf
  local -a in_alias match mbegin mend list_highlights
  # seen_alias is a map of aliases already seen to avoid loops like alias a=b b=a
  local -A seen_alias
  # Pattern for parameter names
  readonly parameter_name_pattern='([A-Za-z_][A-Za-z0-9_]*|[0-9]+)'
  list_highlights=()

  # "R" for round
  # "Q" for square
  # "Y" for curly
  # "T" for [[ ]]
  # "S" for $( ), =( ), <( ), >( )
  # "D" for do/done
  # "$" for 'end' (matches 'foreach' always; also used with cshjunkiequotes in repeat/while)
  # "?" for 'if'/'fi'; also checked by 'elif'/'else'
  # ":" for 'then'
  local braces_stack=$2

  # State machine
  #
  # The states are:
  # - :start:      Command word
  # - :start_of_pipeline:      Start of a 'pipeline' as defined in zshmisc(1).
  #                Only valid when :start: is present
  # - :sudo_opt:   A leading-dash option to a precommand, whether it takes an
  #                argument or not.  (Example: sudo's "-u" or "-i".)
  # - :sudo_arg:   The argument to a precommand's leading-dash option,
  #                when given as a separate word; i.e., "foo" in "-u foo" (two
  #                words) but not in "-ufoo" (one word).
  #    Note:       :sudo_opt: and :sudo_arg: are used for any precommand
  #                declared in ${precommand_options}, not just for sudo(8).
  #                The naming is historical.
  # - :regular:    "Not a command word", and command delimiters are permitted.
  #                Mainly used to detect premature termination of commands.
  # - :always:     The word 'always' in the «{ foo } always { bar }» syntax.
  #
  # When the kind of a word is not yet known, $this_word / $next_word may contain
  # multiple states.  For example, after "sudo -i", the next word may be either
  # another --flag or a command name, hence the state would include both ':start:'
  # and ':sudo_opt:'.
  #
  # The tokens are always added with both leading and trailing colons to serve as
  # word delimiters (an improvised array); [[ $x == *':foo:'* ]] and x=${x//:foo:/}
  # will DTRT regardless of how many elements or repetitions $x has.
  #
  # Handling of redirections: upon seeing a redirection token, we must stall
  # the current state --- that is, the value of $this_word --- for two iterations
  # (one for the redirection operator, one for the word following it representing
  # the redirection target).  Therefore, we set $in_redirection to 2 upon seeing a
  # redirection operator, decrement it each iteration, and stall the current state
  # when it is non-zero.  Thus, upon reaching the next word (the one that follows
  # the redirection operator and target), $this_word will still contain values
  # appropriate for the word immediately following the word that preceded the
  # redirection operator.
  #
  # The "the previous word was a redirection operator" state is not communicated
  # to the next iteration via $next_word/$this_word as usual, but via
  # $in_redirection.  The value of $next_word from the iteration that processed
  # the operator is discarded.
  #
  # $in_redirection is currently used for:
  # - comments
  # - aliases
  # - redirections
  # - parameter elision in command position
  # - 'repeat' loops
  #
  local this_word next_word=':start::start_of_pipeline:'
  integer in_redirection
  # Processing buffer
  local proc_buf="$buf"
  local -a args
  if [[ $zsyh_user_options[interactivecomments] == on ]]; then
    args=(${(zZ+c+)buf})
  else
    args=(${(z)buf})
  fi

  # Special case: $(<*) isn't globbing.
  if [[ $braces_stack == 'S' ]] && (( $+args[3] && ! $+args[4] )) && [[ $args[3] == $'\x29' ]] &&
     [[ $args[1] == *'<'* ]] && _zsh_highlight_main__is_redirection $args[1]; then
    highlight_glob=false
  fi

  while (( $#args )); do
    last_arg=$arg
    arg=$args[1]
    shift args
    if (( $#in_alias )); then
      (( in_alias[1]-- ))
      # Remove leading 0 entries
      in_alias=($in_alias[$in_alias[(i)<1->],-1])
      if (( $#in_alias == 0 )); then
        seen_alias=()
        # start_pos and end_pos are of the alias (previous $arg) here
        _zsh_highlight_main_add_region_highlight $start_pos $end_pos $alias_style
      else
        # We can't unset keys that contain special characters (] \ and some others).
        # More details: https://www.zsh.org/workers/43269
        (){
          local alias_name
          for alias_name in ${(k)seen_alias[(R)<$#in_alias->]}; do
            seen_alias=("${(@kv)seen_alias[(I)^$alias_name]}")
          done
        }
      fi
    fi
    if (( in_param )); then
      (( in_param-- ))
      if (( in_param == 0 )); then
        # start_pos and end_pos are of the '$foo' word (previous $arg) here
        _zsh_highlight_main_add_region_highlight $start_pos $end_pos $param_style
        param_style=""
      fi
    fi

    # Initialize this_word and next_word.
    if (( in_redirection == 0 )); then
      this_word=$next_word
      next_word=':regular:'
    elif (( !in_param )); then
      # Stall $next_word.
      (( --in_redirection ))
    fi

    # Initialize per-"simple command" [zshmisc(1)] variables:
    #
    #   $style               how to highlight $arg
    #   $in_array_assignment boolean flag for "between '(' and ')' of array assignment"
    #   $highlight_glob      boolean flag for "'noglob' is in effect"
    #   $saw_assignment      boolean flag for "was preceded by an assignment"
    #
    style=unknown-token
    if [[ $this_word == *':start:'* ]]; then
      in_array_assignment=false
      if [[ $arg == 'noglob' ]]; then
        highlight_glob=false
      fi
    fi

    if (( $#in_alias == 0 && in_param == 0 )); then
      # Compute the new $start_pos and $end_pos, skipping over whitespace in $buf.
      [[ "$proc_buf" = (#b)(#s)(''([ $'\t']|[\\]$'\n')#)(?|)* ]]
      # The first, outer parenthesis
      integer offset="${#match[1]}"
      (( start_pos = end_pos + offset ))
      (( end_pos = start_pos + $#arg ))

      # The zsh lexer considers ';' and newline to be the same token, so
      # ${(z)} converts all newlines to semicolons. Convert them back here to
      # make later processing simpler.
      [[ $arg == ';' && ${match[3]} == $'\n' ]] && arg=$'\n'

      # Compute the new $proc_buf. We advance it
      # (chop off characters from the beginning)
      # beyond what end_pos points to, by skipping
      # as many characters as end_pos was advanced.
      #
      # end_pos was advanced by $offset (via start_pos)
      # and by $#arg. Note the `start_pos=$end_pos`
      # below.
      #
      # As for the [,len]. We could use [,len-start_pos+offset]
      # here, but to make it easier on eyes, we use len and
      # rely on the fact that Zsh simply handles that. The
      # length of proc_buf is len-start_pos+offset because
      # we're chopping it to match current start_pos, so its
      # length matches the previous value of start_pos.
      #
      # Why [,-1] is slower than [,length] isn't clear.
      proc_buf="${proc_buf[offset + $#arg + 1,len]}"
    fi

    # Handle the INTERACTIVE_COMMENTS option.
    #
    # We use the (Z+c+) flag so the entire comment is presented as one token in $arg.
    if [[ $zsyh_user_options[interactivecomments] == on && $arg[1] == $histchars[3] ]]; then
      if [[ $this_word == *(':regular:'|':start:')* ]]; then
        style=comment
      else
        style=unknown-token # prematurely terminated
      fi
      _zsh_highlight_main_add_region_highlight $start_pos $end_pos $style
      # Stall this arg
      in_redirection=1
      continue
    fi

    if [[ $this_word == *':start:'* ]] && ! (( in_redirection )); then
      # Expand aliases.
      # An alias is ineligible for expansion while it's being expanded (see #652/#653).
      _zsh_highlight_main__type "$arg" "$(( ! ${+seen_alias[$arg]} ))"
      local res="$REPLY"
      if [[ $res == "alias" ]]; then
        # Mark insane aliases as unknown-token (cf. #263).
        if [[ $arg == ?*=* ]]; then
          _zsh_highlight_main_add_region_highlight $start_pos $end_pos unknown-token
          continue
        fi
        seen_alias[$arg]=$#in_alias
        _zsh_highlight_main__resolve_alias $arg
        local -a alias_args
        # Elision is desired in case alias x=''
        if [[ $zsyh_user_options[interactivecomments] == on ]]; then
          alias_args=(${(zZ+c+)REPLY})
        else
          alias_args=(${(z)REPLY})
        fi
        args=( $alias_args $args )
        if (( $#in_alias == 0 )); then
          alias_style=alias
        else
          # Transfer the count of this arg to the new element about to be appended.
          (( in_alias[1]-- ))
        fi
        # Add one because we will in_alias[1]-- on the next loop iteration so
        # this iteration should be considered in in_alias as well
        in_alias=( $(($#alias_args + 1)) $in_alias )
        (( in_redirection++ )) # Stall this arg
        continue
      else
        _zsh_highlight_main_highlighter_expand_path $arg
        _zsh_highlight_main__type "$REPLY" 0
        res="$REPLY"
      fi
    fi

    # Analyse the current word.
    if _zsh_highlight_main__is_redirection $arg ; then
      if (( in_redirection == 1 )); then
        # Two consecutive redirection operators is an error.
        _zsh_highlight_main_add_region_highlight $start_pos $end_pos unknown-token
      else
        in_redirection=2
        _zsh_highlight_main_add_region_highlight $start_pos $end_pos redirection
      fi
      continue
    elif [[ $arg == '{'${~parameter_name_pattern}'}' ]] && _zsh_highlight_main__is_redirection $args[1]; then
      # named file descriptor: {foo}>&2
      in_redirection=3
      _zsh_highlight_main_add_region_highlight $start_pos $end_pos named-fd
      continue
    fi

    # Expand parameters.
    if (( ! in_param )) && _zsh_highlight_main_highlighter__try_expand_parameter "$arg"; then
      # That's not entirely correct --- if the parameter's value happens to be a reserved
      # word, the parameter expansion will be highlighted as a reserved word --- but that
      # incorrectness is outweighed by the usability improvement of permitting the use of
      # parameters that refer to commands, functions, and builtins.
      () {
        local -a words; words=( "${reply[@]}" )
        if (( $#words == 0 )) && (( ! in_redirection )); then
          # Parameter elision is happening
          (( ++in_redirection ))
          _zsh_highlight_main_add_region_highlight $start_pos $end_pos comment
          continue
        else
          (( in_param = 1 + $#words ))
          args=( $words $args )
          arg=$args[1]
          _zsh_highlight_main__type "$arg" 0
          res=$REPLY
        fi
      }
    fi

    # Parse the sudo command line
    if (( ! in_redirection )); then
      if [[ $this_word == *':sudo_opt:'* ]]; then
        if [[ -n $flags_with_argument ]] &&
           { 
             # Trenary
             if [[ -n $flags_sans_argument ]]
             then [[ $arg == '-'[$flags_sans_argument]#[$flags_with_argument] ]]
             else [[ $arg == '-'[$flags_with_argument] ]]
             fi
           } then
          # Flag that requires an argument
          this_word=${this_word//:start:/}
          next_word=':sudo_arg:'
        elif [[ -n $flags_with_argument ]] &&
             {
               # Trenary
               if [[ -n $flags_sans_argument ]]
               then [[ $arg == '-'[$flags_sans_argument]#[$flags_with_argument]* ]]
               else [[ $arg == '-'[$flags_with_argument]* ]]
               fi
             } then
          # Argument attached in the same word
          this_word=${this_word//:start:/}
          next_word+=':start:'
          next_word+=':sudo_opt:'
        elif [[ -n $flags_sans_argument ]] &&
             [[ $arg == '-'[$flags_sans_argument]# ]]; then
          # Flag that requires no argument
          this_word=':sudo_opt:'
          next_word+=':start:'
          next_word+=':sudo_opt:'
        elif [[ -n $flags_solo ]] && 
             {
               # Trenary
               if [[ -n $flags_sans_argument ]]
               then [[ $arg == '-'[$flags_sans_argument]#[$flags_solo]* ]]
               else [[ $arg == '-'[$flags_solo]* ]]
               fi
             } then
          # Solo flags
          this_word=':sudo_opt:'
          next_word=':regular:' # no :start:, nor :sudo_opt: since we don't know whether the solo flag takes an argument or not
        elif [[ $arg == '-'* ]]; then
          # Unknown flag.  We don't know whether it takes an argument or not,
          # so modify $next_word as we do for flags that require no argument.
          # With that behaviour, if the flag in fact takes no argument we'll
          # highlight the inner command word correctly, and if it does take an
          # argument we'll highlight the command word correctly if the argument
          # was given in the same shell word as the flag (as in '-uphy1729' or
          # '--user=phy1729' without spaces).
          this_word=':sudo_opt:'
          next_word+=':start:'
          next_word+=':sudo_opt:'
        else
          # Not an option flag; nothing to do.  (If the command line is
          # syntactically valid, ${this_word//:sudo_opt:/} should be
          # non-empty now.)
          this_word=${this_word//:sudo_opt:/}
        fi
      elif [[ $this_word == *':sudo_arg:'* ]]; then
        next_word+=':sudo_opt:'
        next_word+=':start:'
      fi
    fi

    # The Great Fork: is this a command word?  Is this a non-command word?
    if [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR:#"$arg"} ]] &&
       [[ $braces_stack != *T* || $arg != ('||'|'&&') ]]; then

      # First, determine the style of the command separator itself.
      if _zsh_highlight_main__stack_pop T || _zsh_highlight_main__stack_pop Q; then
        # Missing closing square bracket(s)
        style=unknown-token
      elif $in_array_assignment; then
        case $arg in
          # Literal newlines are just fine.
          ($'\n') style=commandseparator;;
          # Semicolons are parsed the same way as literal newlines.  Nevertheless,
          # highlight them as errors since they're probably unintended.  Compare
          # issue #691.
          (';') style=unknown-token;;
          # Other command separators aren't allowed.
          (*) style=unknown-token;;
        esac
      elif [[ $this_word == *':regular:'* ]]; then
        style=commandseparator
      elif [[ $this_word == *':start:'* ]] && [[ $arg == $'\n' ]]; then
        style=commandseparator
      elif [[ $this_word == *':start:'* ]] && [[ $arg == ';' ]] && (( $#in_alias )); then
        style=commandseparator 
      else
        # Empty commands (semicolon follows nothing) are valid syntax.
        # However, in interactive use they are likely to be erroneous;
        # therefore, we highlight them as errors.
        #
        # Alias definitions are exempted from this check to allow multiline aliases
        # with explicit (redundant) semicolons: «alias foo=$'bar;\nbaz'» (issue #677).
        #
        # See also #691 about possibly changing the style used here. 
        style=unknown-token
      fi

      # Second, determine the style of next_word.
      if [[ $arg == $'\n' ]] && $in_array_assignment; then
        # literal newline inside an array assignment
        next_word=':regular:'
      elif [[ $arg == ';' ]] && $in_array_assignment; then
        # literal semicolon inside an array assignment
        next_word=':regular:'
      else
        next_word=':start:'
        highlight_glob=true
        saw_assignment=false
        (){
          local alias_name
          for alias_name in ${(k)seen_alias[(R)<$#in_alias->]}; do
            # We can't unset keys that contain special characters (] \ and some others).
            # More details: https://www.zsh.org/workers/43269
            seen_alias=("${(@kv)seen_alias[(I)^$alias_name]}")
          done
        }
        if [[ $arg != '|' && $arg != '|&' ]]; then
          next_word+=':start_of_pipeline:'
        fi
      fi

    elif ! (( in_redirection)) && [[ $this_word == *':always:'* && $arg == 'always' ]]; then
      # try-always construct
      style=reserved-word # de facto a reserved word, although not de jure
      highlight_glob=true
      saw_assignment=false
      next_word=':start::start_of_pipeline:' # only left brace is allowed, apparently
    elif ! (( in_redirection)) && [[ $this_word == *':start:'* ]]; then # $arg is the command word
      if (( ${+precommand_options[$arg]} )) && _zsh_highlight_main__is_runnable $arg; then
        style=precommand
        () {
          set -- "${(@s.:.)precommand_options[$arg]}"
          flags_with_argument=$1
          flags_sans_argument=$2
          flags_solo=$3
        }
        next_word=${next_word//:regular:/}
        next_word+=':sudo_opt:'
        next_word+=':start:'
        if [[ $arg == 'exec' || $arg == 'env' ]]; then
          # To allow "exec 2>&1;" and "env | grep" where there's no command word
          next_word+=':regular:'
        fi
      else
        case $res in
          (reserved)    # reserved word
                        style=reserved-word
                        # Match braces and handle special cases.
                        case $arg in
                          (time|nocorrect)
                            next_word=${next_word//:regular:/}
                            next_word+=':start:'
                            ;;
                          ($'\x7b')
                            braces_stack='Y'"$braces_stack"
                            ;;
                          ($'\x7d')
                            # We're at command word, so no need to check $right_brace_is_recognised_everywhere
                            _zsh_highlight_main__stack_pop 'Y' reserved-word
                            if [[ $style == reserved-word ]]; then
                              next_word+=':always:'
                            fi
                            ;;
                          ($'\x5b\x5b')
                            braces_stack='T'"$braces_stack"
                            ;;
                          ('do')
                            braces_stack='D'"$braces_stack"
                            ;;
                          ('done')
                            _zsh_highlight_main__stack_pop 'D' reserved-word
                            ;;
                          ('if')
                            braces_stack=':?'"$braces_stack"
                            ;;
                          ('then')
                            _zsh_highlight_main__stack_pop ':' reserved-word
                            ;;
                          ('elif')
                            if [[ ${braces_stack[1]} == '?' ]]; then
                              braces_stack=':'"$braces_stack"
                            else
                              style=unknown-token
                            fi
                            ;;
                          ('else')
                            if [[ ${braces_stack[1]} == '?' ]]; then
                              :
                            else
                              style=unknown-token
                            fi
                            ;;
                          ('fi')
                            _zsh_highlight_main__stack_pop '?'
                            ;;
                          ('foreach')
                            braces_stack='$'"$braces_stack"
                            ;;
                          ('end')
                            _zsh_highlight_main__stack_pop '$' reserved-word
                            ;;
                          ('repeat')
                            # skip the repeat-count word
                            in_redirection=2
                            # The redirection mechanism assumes $this_word describes the word
                            # following the redirection.  Make it so.
                            #
                            # That word can be a command word with shortloops (`repeat 2 ls`)
                            # or a command separator (`repeat 2; ls` or `repeat 2; do ls; done`).
                            #
                            # The repeat-count word will be handled like a redirection target.
                            this_word=':start::regular:'
                            ;;
                          ('!')
                            if [[ $this_word != *':start_of_pipeline:'* ]]; then
                              style=unknown-token
                            else
                              # '!' reserved word at start of pipeline; style already set above
                            fi
                            ;;
                        esac
                        if $saw_assignment && [[ $style != unknown-token ]]; then
                          style=unknown-token
                        fi
                        ;;
          ('suffix alias')
                        style=suffix-alias
                        ;;
          ('global alias')
                        style=global-alias
                        ;;
          (alias)       :;;
          (builtin)     style=builtin
                        [[ $arg == $'\x5b' ]] && braces_stack='Q'"$braces_stack"
                        ;;
          (function)    style=function;;
          (command)     style=command;;
          (hashed)      style=hashed-command;;
          (none)        if (( ! in_param )) && _zsh_highlight_main_highlighter_check_assign; then
                          _zsh_highlight_main_add_region_highlight $start_pos $end_pos assign
                          local i=$(( arg[(i)=] + 1 ))
                          saw_assignment=true
                          if [[ $arg[i] == '(' ]]; then
                            in_array_assignment=true
                            _zsh_highlight_main_add_region_highlight start_pos+i-1 start_pos+i reserved-word
                          else
                            # assignment to a scalar parameter.
                            # (For array assignments, the command doesn't start until the ")" token.)
                            # 
                            # Discard  :start_of_pipeline:, if present, as '!' is not valid
                            # after assignments.
                            next_word+=':start:'
                            if (( i <= $#arg )); then
                              () {
                                local highlight_glob=false
                                [[ $zsyh_user_options[globassign] == on ]] && highlight_glob=true
                                _zsh_highlight_main_highlighter_highlight_argument $i
                              }
                            fi
                          fi
                          continue
                        elif (( ! in_param )) &&
                             [[ $arg[0,1] = $histchars[0,1] ]] && (( $#arg[0,2] == 2 )); then
                          style=history-expansion
                        elif (( ! in_param )) &&
                             [[ $arg[0,1] == $histchars[2,2] ]]; then
                          style=history-expansion
                        elif (( ! in_param )) &&
                             ! $saw_assignment &&
                             [[ $arg[1,2] == '((' ]]; then
                          # Arithmetic evaluation.
                          #
                          # Note: prior to zsh-5.1.1-52-g4bed2cf (workers/36669), the ${(z)...}
                          # splitter would only output the '((' token if the matching '))' had
                          # been typed.  Therefore, under those versions of zsh, BUFFER="(( 42"
                          # would be highlighted as an error until the matching "))" are typed.
                          #
                          # We highlight just the opening parentheses, as a reserved word; this
                          # is how [[ ... ]] is highlighted, too.
                          _zsh_highlight_main_add_region_highlight $start_pos $((start_pos + 2)) reserved-word
                          if [[ $arg[-2,-1] == '))' ]]; then
                            _zsh_highlight_main_add_region_highlight $((end_pos - 2)) $end_pos reserved-word
                          fi
                          continue
                        elif (( ! in_param )) &&
                             [[ $arg == '()' ]]; then
                          # anonymous function
                          style=reserved-word
                        elif (( ! in_param )) &&
                             ! $saw_assignment &&
                             [[ $arg == $'\x28' ]]; then
                          # subshell
                          style=reserved-word
                          braces_stack='R'"$braces_stack"
                        elif (( ! in_param )) &&
                             [[ $arg == $'\x29' ]]; then
                          # end of subshell or command substitution
                          if _zsh_highlight_main__stack_pop 'S'; then
                            REPLY=$start_pos
                            reply=($list_highlights)
                            return 0
                          fi
                          _zsh_highlight_main__stack_pop 'R' reserved-word
                        else
                          if _zsh_highlight_main_highlighter_check_path $arg 1; then
                            style=$REPLY
                          else
                            style=unknown-token
                          fi
                        fi
                        ;;
          (*)           _zsh_highlight_main_add_region_highlight $start_pos $end_pos arg0_$res
                        continue
                        ;;
        esac
      fi
      if [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_CONTROL_FLOW:#"$arg"} ]]; then
        next_word=':start::start_of_pipeline:'
      fi
    elif _zsh_highlight_main__is_global_alias "$arg"; then # $arg is a global alias that isn't in command position
      style=global-alias
    else # $arg is a non-command word
      case $arg in
        ($'\x29')
                  # subshell or end of array assignment
                  if $in_array_assignment; then
                    _zsh_highlight_main_add_region_highlight $start_pos $end_pos assign
                    _zsh_highlight_main_add_region_highlight $start_pos $end_pos reserved-word
                    in_array_assignment=false
                    next_word+=':start:'
                    continue
                  elif (( in_redirection )); then
                    style=unknown-token
                  else
                    if _zsh_highlight_main__stack_pop 'S'; then
                      REPLY=$start_pos
                      reply=($list_highlights)
                      return 0
                    fi
                    _zsh_highlight_main__stack_pop 'R' reserved-word
                  fi
                  ;;
        ($'\x28\x29')
                  # possibly a function definition
                  if (( in_redirection )) || $in_array_assignment; then
                    style=unknown-token
                  else
                    if [[ $zsyh_user_options[multifuncdef] == on ]] || false # TODO: or if the previous word was a command word
                    then
                      next_word+=':start::start_of_pipeline:'
                    fi
                    style=reserved-word
                  fi
                  ;;
        (*)       if false; then
                  elif [[ $arg = $'\x7d' ]] && $right_brace_is_recognised_everywhere; then
                    # Parsing rule: {
                    #
                    #     Additionally, `tt(})' is recognized in any position if neither the
                    #     tt(IGNORE_BRACES) option nor the tt(IGNORE_CLOSE_BRACES) option is set.
                    if (( in_redirection )) || $in_array_assignment; then
                      style=unknown-token
                    else
                      _zsh_highlight_main__stack_pop 'Y' reserved-word
                      if [[ $style == reserved-word ]]; then
                        next_word+=':always:'
                      fi
                    fi
                  elif [[ $arg[0,1] = $histchars[0,1] ]] && (( $#arg[0,2] == 2 )); then
                    style=history-expansion
                  elif [[ $arg == $'\x5d\x5d' ]] && _zsh_highlight_main__stack_pop 'T' reserved-word; then
                    :
                  elif [[ $arg == $'\x5d' ]] && _zsh_highlight_main__stack_pop 'Q' builtin; then
                    :
                  else
                    _zsh_highlight_main_highlighter_highlight_argument 1 $(( 1 != in_redirection ))
                    continue
                  fi
                  ;;
      esac
    fi
    _zsh_highlight_main_add_region_highlight $start_pos $end_pos $style
  done
  (( $#in_alias )) && in_alias=() _zsh_highlight_main_add_region_highlight $start_pos $end_pos $alias_style
  (( in_param == 1 )) && in_param=0 _zsh_highlight_main_add_region_highlight $start_pos $end_pos $param_style
  [[ "$proc_buf" = (#b)(#s)(([[:space:]]|\\$'\n')#) ]]
  REPLY=$(( end_pos + ${#match[1]} - 1 ))
  reply=($list_highlights)
  return $(( $#braces_stack > 0 ))
}

# Check if $arg is variable assignment
_zsh_highlight_main_highlighter_check_assign()
{
    setopt localoptions extended_glob
    [[ $arg == [[:alpha:]_][[:alnum:]_]#(|\[*\])(|[+])=* ]] ||
      [[ $arg == [0-9]##(|[+])=* ]]
}

_zsh_highlight_main_highlighter_highlight_path_separators()
{
  local pos style_pathsep
  style_pathsep=$1_pathseparator
  reply=()
  [[ -z "$ZSH_HIGHLIGHT_STYLES[$style_pathsep]" || "$ZSH_HIGHLIGHT_STYLES[$1]" == "$ZSH_HIGHLIGHT_STYLES[$style_pathsep]" ]] && return 0
  for (( pos = start_pos; $pos <= end_pos; pos++ )) ; do
    if [[ $BUFFER[pos] == / ]]; then
      reply+=($((pos - 1)) $pos $style_pathsep)
    fi
  done
}

# Check if $1 is a path.
# If yes, return 0 and in $REPLY the style to use.
# Else, return non-zero (and the contents of $REPLY is undefined).
#
# $2 should be non-zero iff we're in command position.
_zsh_highlight_main_highlighter_check_path()
{
  _zsh_highlight_main_highlighter_expand_path "$1"
  local expanded_path="$REPLY" tmp_path
  integer in_command_position=$2

  if [[ $zsyh_user_options[autocd] == on ]]; then
    integer autocd=1
  else
    integer autocd=0
  fi

  if (( in_command_position )); then
    # ### Currently, this value is never returned: either it's overwritten
    # ### below, or the return code is non-zero
    REPLY=arg0
  else
    REPLY=path
  fi

  if [[ ${1[1]} == '=' && $1 == ??* && ${1[2]} != $'\x28' && $zsyh_user_options[equals] == 'on' && $expanded_path[1] != '/' ]]; then
    REPLY=unknown-token # will error out if executed
    return 0
  fi

  [[ -z $expanded_path ]] && return 1

  # Check if this is a blacklisted path
  if [[ $expanded_path[1] == / ]]; then
    tmp_path=$expanded_path
  else
    tmp_path=$PWD/$expanded_path
  fi
  tmp_path=$tmp_path:a

  while [[ $tmp_path != / ]]; do
    [[ -n ${(M)ZSH_HIGHLIGHT_DIRS_BLACKLIST:#$tmp_path} ]] && return 1
    tmp_path=$tmp_path:h
  done

  if (( in_command_position )); then
    if [[ -x $expanded_path ]]; then
      if (( autocd )); then
        if [[ -d $expanded_path ]]; then
          REPLY=autodirectory
        fi
        return 0
      elif [[ ! -d $expanded_path ]]; then
        # ### This seems unreachable for the current callers
        return 0
      fi
    fi
  else
    if [[ -L $expanded_path || -e $expanded_path ]]; then
      return 0
    fi
  fi

  # Search the path in CDPATH
  if [[ $expanded_path != /* ]] && (( autocd || ! in_command_position )); then
    # TODO: When we've dropped support for pre-5.0.6 zsh, use the *(Y1) glob qualifier here.
    local cdpath_dir
    for cdpath_dir in $cdpath ; do
      if [[ -d "$cdpath_dir/$expanded_path" && -x "$cdpath_dir/$expanded_path" ]]; then
        if (( in_command_position && autocd )); then
          REPLY=autodirectory
        fi
        return 0
      fi
    done
  fi

  # If dirname($1) doesn't exist, neither does $1.
  [[ ! -d ${expanded_path:h} ]] && return 1

  # If this word ends the buffer, check if it's the prefix of a valid path.
  if (( has_end && (len == end_pos) )) &&
     (( ! $#in_alias )) &&
     [[ $WIDGET != zle-line-finish ]]; then
    # TODO: When we've dropped support for pre-5.0.6 zsh, use the *(Y1) glob qualifier here.
    local -a tmp
    if (( in_command_position )); then
      # We include directories even when autocd is enabled, because those
      # directories might contain executable files: e.g., BUFFER="/bi" en route
      # to typing "/bin/sh".
      tmp=( ${expanded_path}*(N-*,N-/) )
    else
      tmp=( ${expanded_path}*(N) )
    fi
    (( ${+tmp[1]} )) && REPLY=path_prefix && return 0
  fi

  # It's not a path.
  return 1
}

# Highlight an argument and possibly special chars in quotes starting at $1 in $arg
# This command will at least highlight $1 to end_pos with the default style
# If $2 is set to 0, the argument cannot be highlighted as an option.
#
# This function currently assumes it's never called for the command word.
_zsh_highlight_main_highlighter_highlight_argument()
{
  local base_style=default i=$1 option_eligible=${2:-1} path_eligible=1 ret start style
  local -a highlights

  local -a match mbegin mend
  local MATCH; integer MBEGIN MEND

  case "$arg[i]" in
    '%')
      if [[ $arg[i+1] == '?' ]]; then
        (( i += 2 ))
      fi
      ;;
    '-')
      if (( option_eligible )); then
        if [[ $arg[i+1] == - ]]; then
          base_style=double-hyphen-option
        else
          base_style=single-hyphen-option
        fi
        path_eligible=0
      fi
      ;;
    '=')
      if [[ $arg[i+1] == $'\x28' ]]; then
        (( i += 2 ))
        _zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,-1]
        ret=$?
        (( i += REPLY ))
        highlights+=(
          $(( start_pos + $1 - 1 )) $(( start_pos + i )) process-substitution
          $(( start_pos + $1 - 1 )) $(( start_pos + $1 + 1 )) process-substitution-delimiter
          $reply
        )
        if (( ret == 0 )); then
          highlights+=($(( start_pos + i - 1 )) $(( start_pos + i )) process-substitution-delimiter)
        fi
      fi
  esac

  # This loop is a hot path.  Keep it fast!
  (( --i ))
  while (( ++i <= $#arg )); do
    i=${arg[(ib.i.)[\\\'\"\`\$\<\>\*\?]]}
    case "$arg[$i]" in
      "") break;;
      "\\") (( i += 1 )); continue;;
      "'")
        _zsh_highlight_main_highlighter_highlight_single_quote $i
        (( i = REPLY ))
        highlights+=($reply)
        ;;
      '"')
        _zsh_highlight_main_highlighter_highlight_double_quote $i
        (( i = REPLY ))
        highlights+=($reply)
        ;;
      '`')
        _zsh_highlight_main_highlighter_highlight_backtick $i
        (( i = REPLY ))
        highlights+=($reply)
        ;;
      '$')
        if [[ $arg[i+1] != "'" ]]; then
          path_eligible=0
        fi
        if [[ $arg[i+1] == "'" ]]; then
          _zsh_highlight_main_highlighter_highlight_dollar_quote $i
          (( i = REPLY ))
          highlights+=($reply)
          continue
        elif [[ $arg[i+1] == $'\x28' ]]; then
          if [[ $arg[i+2] == $'\x28' ]] && _zsh_highlight_main_highlighter_highlight_arithmetic $i; then
            # Arithmetic expansion
            (( i = REPLY ))
            highlights+=($reply)
            continue
          fi
          start=$i
          (( i += 2 ))
          _zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,-1]
          ret=$?
          (( i += REPLY ))
          highlights+=(
            $(( start_pos + start - 1)) $(( start_pos + i )) command-substitution-unquoted
            $(( start_pos + start - 1)) $(( start_pos + start + 1)) command-substitution-delimiter-unquoted
            $reply
          )
          if (( ret == 0 )); then
            highlights+=($(( start_pos + i - 1)) $(( start_pos + i )) command-substitution-delimiter-unquoted)
          fi
          continue
        fi
        while [[ $arg[i+1] == [=~#+'^'] ]]; do
          (( i += 1 ))
        done
        if [[ $arg[i+1] == [*@#?$!-] ]]; then
          (( i += 1 ))
        fi;;
      [\<\>])
        if [[ $arg[i+1] == $'\x28' ]]; then # \x28 = open paren
          start=$i
          (( i += 2 ))
          _zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,-1]
          ret=$?
          (( i += REPLY ))
          highlights+=(
            $(( start_pos + start - 1)) $(( start_pos + i )) process-substitution
            $(( start_pos + start - 1)) $(( start_pos + start + 1 )) process-substitution-delimiter
            $reply
          )
          if (( ret == 0 )); then
            highlights+=($(( start_pos + i - 1)) $(( start_pos + i )) process-substitution-delimiter)
          fi
          continue
        fi
        ;|
      *)
        if $highlight_glob &&
           [[ $zsyh_user_options[multios] == on || $in_redirection -eq 0 ]] &&
           [[ ${arg[$i]} =~ ^[*?] || ${arg:$i-1} =~ ^\<[0-9]*-[0-9]*\> ]]; then
          highlights+=($(( start_pos + i - 1 )) $(( start_pos + i + $#MATCH - 1)) globbing)
          (( i += $#MATCH - 1 ))
          path_eligible=0
        else
          continue
        fi
        ;;
    esac
  done

  if (( path_eligible )); then
    if (( in_redirection )) && [[ $last_arg == *['<>']['&'] && $arg[$1,-1] == (<0->|p|-) ]]; then
      if [[ $arg[$1,-1] == (p|-) ]]; then
        base_style=redirection
      else
        base_style=numeric-fd
      fi
    # This function is currently never called for the command word, so $2 is hard-coded as 0.
    elif _zsh_highlight_main_highlighter_check_path $arg[$1,-1] 0; then
      base_style=$REPLY
      _zsh_highlight_main_highlighter_highlight_path_separators $base_style
      highlights+=($reply)
    fi
  fi

  highlights=($(( start_pos + $1 - 1 )) $end_pos $base_style $highlights)
  _zsh_highlight_main_add_many_region_highlights $highlights
}

# Quote Helper Functions
#
# $arg is expected to be set to the current argument
# $start_pos is expected to be set to the start of $arg in $BUFFER
# $1 is the index in $arg which starts the quote
# $REPLY is returned as the end of quote index in $arg
# $reply is returned as an array of region_highlight additions

# Highlight single-quoted strings
_zsh_highlight_main_highlighter_highlight_single_quote()
{
  local arg1=$1 i q=\' style
  i=$arg[(ib:arg1+1:)$q]
  reply=()

  if [[ $zsyh_user_options[rcquotes] == on ]]; then
    while [[ $arg[i+1] == "'" ]]; do
      reply+=($(( start_pos + i - 1 )) $(( start_pos + i + 1 )) rc-quote)
      (( i++ ))
      i=$arg[(ib:i+1:)$q]
    done
  fi

  if [[ $arg[i] == "'" ]]; then
    style=single-quoted-argument
  else
    # If unclosed, i points past the end
    (( i-- ))
    style=single-quoted-argument-unclosed
  fi
  reply=($(( start_pos + arg1 - 1 )) $(( start_pos + i )) $style $reply)
  REPLY=$i
}

# Highlight special chars inside double-quoted strings
_zsh_highlight_main_highlighter_highlight_double_quote()
{
  local -a breaks match mbegin mend saved_reply
  local MATCH; integer last_break=$(( start_pos + $1 - 1 )) MBEGIN MEND
  local i j k ret style
  reply=()

  for (( i = $1 + 1 ; i <= $#arg ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      ('"') break;;
      ('`') saved_reply=($reply)
            _zsh_highlight_main_highlighter_highlight_backtick $i
            (( i = REPLY ))
            reply=($saved_reply $reply)
            continue
            ;;
      ('$') style=dollar-double-quoted-argument
            # Look for an alphanumeric parameter name.
            if [[ ${arg:$i} =~ ^([A-Za-z_][A-Za-z0-9_]*|[0-9]+) ]] ; then
              (( k += $#MATCH )) # highlight the parameter name
              (( i += $#MATCH )) # skip past it
            elif [[ ${arg:$i} =~ ^[{]([A-Za-z_][A-Za-z0-9_]*|[0-9]+)[}] ]] ; then
              (( k += $#MATCH )) # highlight the parameter name and braces
              (( i += $#MATCH )) # skip past it
            elif [[ $arg[i+1] == '$' ]]; then
              # $$ - pid
              (( k += 1 )) # highlight both dollar signs
              (( i += 1 )) # don't consider the second one as introducing another parameter expansion
            elif [[ $arg[i+1] == [-#*@?] ]]; then
              # $#, $*, $@, $?, $- - like $$ above
              (( k += 1 )) # highlight both dollar signs
              (( i += 1 )) # don't consider the second one as introducing another parameter expansion
            elif [[ $arg[i+1] == $'\x28' ]]; then
              saved_reply=($reply)
              if [[ $arg[i+2] == $'\x28' ]] && _zsh_highlight_main_highlighter_highlight_arithmetic $i; then
                # Arithmetic expansion
                (( i = REPLY ))
                reply=($saved_reply $reply)
                continue
              fi

              breaks+=( $last_break $(( start_pos + i - 1 )) )
              (( i += 2 ))
              _zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,-1]
              ret=$?
              (( i += REPLY ))
              last_break=$(( start_pos + i ))
              reply=(
                $saved_reply
                $j $(( start_pos + i )) command-substitution-quoted
                $j $(( j + 2 )) command-substitution-delimiter-quoted
                $reply
              )
              if (( ret == 0 )); then
                reply+=($(( start_pos + i - 1 )) $(( start_pos + i )) command-substitution-delimiter-quoted)
              fi
              continue
            else
              continue
            fi
            ;;
      "\\") style=back-double-quoted-argument
            if [[ \\\`\"\$${histchars[1]} == *$arg[$i+1]* ]]; then
              (( k += 1 )) # Color following char too.
              (( i += 1 )) # Skip parsing the escaped char.
            else
              continue
            fi
            ;;
      ($histchars[1]) # ! - may be a history expansion
            if [[ $arg[i+1] != ('='|$'\x28'|$'\x7b'|[[:blank:]]) ]]; then
              style=history-expansion
            else
              continue
            fi
            ;;
      *) continue ;;

    esac
    reply+=($j $k $style)
  done

  if [[ $arg[i] == '"' ]]; then
    style=double-quoted-argument
  else
    # If unclosed, i points past the end
    (( i-- ))
    style=double-quoted-argument-unclosed
  fi
  (( last_break != start_pos + i )) && breaks+=( $last_break $(( start_pos + i )) )
  saved_reply=($reply)
  reply=()
  for 1 2 in $breaks; do
    (( $1 != $2 )) && reply+=($1 $2 $style)
  done
  reply+=($saved_reply)
  REPLY=$i
}

# Highlight special chars inside dollar-quoted strings
_zsh_highlight_main_highlighter_highlight_dollar_quote()
{
  local -a match mbegin mend
  local MATCH; integer MBEGIN MEND
  local i j k style
  local AA
  integer c
  reply=()

  for (( i = $1 + 2 ; i <= $#arg ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      "'") break;;
      "\\") style=back-dollar-quoted-argument
            for (( c = i + 1 ; c <= $#arg ; c += 1 )); do
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
                style=unknown-token
              fi
              (( k += 1 )) # Color following char too.
              (( i += 1 )) # Skip parsing the escaped char.
            fi
            ;;
      *) continue ;;

    esac
    reply+=($j $k $style)
  done

  if [[ $arg[i] == "'" ]]; then
    style=dollar-quoted-argument
  else
    # If unclosed, i points past the end
    (( i-- ))
    style=dollar-quoted-argument-unclosed
  fi
  reply=($(( start_pos + $1 - 1 )) $(( start_pos + i )) $style $reply)
  REPLY=$i
}

# Highlight backtick substitutions
_zsh_highlight_main_highlighter_highlight_backtick()
{
  # buf is the contents of the backticks with a layer of backslashes removed.
  # last is the index of arg for the start of the string to be copied into buf.
  #     It is either one past the beginning backtick or one past the last backslash.
  # offset is a count of consumed \ (the delta between buf and arg).
  # offsets is an array indexed by buf offset of when the delta between buf and arg changes.
  #     It is sparse, so search backwards to the last value
  local buf highlight style=back-quoted-argument-unclosed style_end
  local -i arg1=$1 end_ i=$1 last offset=0 start subshell_has_end=0
  local -a highlight_zone highlights offsets
  reply=()

  last=$(( arg1 + 1 ))
  # Remove one layer of backslashes and find the end
  while i=$arg[(ib:i+1:)[\\\\\`]]; do # find the next \ or `
    if (( i > $#arg )); then
      buf=$buf$arg[last,i]
      offsets[i-arg1-offset]='' # So we never index past the end
      (( i-- ))
      subshell_has_end=$(( has_end && (start_pos + i == len) ))
      break
    fi

    if [[ $arg[i] == '\' ]]; then
      (( i++ ))
      # POSIX XCU 2.6.3
      if [[ $arg[i] == ('$'|'`'|'\') ]]; then
        buf=$buf$arg[last,i-2]
        (( offset++ ))
        # offsets is relative to buf, so adjust by -arg1
        offsets[i-arg1-offset]=$offset
      else
        buf=$buf$arg[last,i-1]
      fi
    else # it's an unquoted ` and this is the end
      style=back-quoted-argument
      style_end=back-quoted-argument-delimiter
      buf=$buf$arg[last,i-1]
      offsets[i-arg1-offset]='' # So we never index past the end
      break
    fi
    last=$i
  done

  _zsh_highlight_main_highlighter_highlight_list 0 '' $subshell_has_end $buf

  # Munge the reply to account for removed backslashes
  for start end_ highlight in $reply; do
    start=$(( start_pos + arg1 + start + offsets[(Rb:start:)?*] ))
    end_=$(( start_pos + arg1 + end_ + offsets[(Rb:end_:)?*] ))
    highlights+=($start $end_ $highlight)
    if [[ $highlight == back-quoted-argument-unclosed && $style == back-quoted-argument ]]; then
      # An inner backtick command substitution is unclosed, but this level is closed
      style_end=unknown-token
    fi
  done

  reply=(
    $(( start_pos + arg1 - 1 )) $(( start_pos + i )) $style
    $(( start_pos + arg1 - 1 )) $(( start_pos + arg1 )) back-quoted-argument-delimiter
    $highlights
  )
  if (( $#style_end )); then
    reply+=($(( start_pos + i - 1)) $(( start_pos + i )) $style_end)
  fi
  REPLY=$i
}

# Highlight special chars inside arithmetic expansions
_zsh_highlight_main_highlighter_highlight_arithmetic()
{
  local -a saved_reply
  local style
  integer i j k paren_depth ret
  reply=()

  for (( i = $1 + 3 ; i <= end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      [\'\"\\@{}])
        style=unknown-token
        ;;
      '(')
        (( paren_depth++ ))
        continue
        ;;
      ')')
        if (( paren_depth )); then
          (( paren_depth-- ))
          continue
        fi
        [[ $arg[i+1] == ')' ]] && { (( i++ )); break; }
        # Special case ) at the end of the buffer to avoid flashing command substitution for a character
        (( has_end && (len == k) )) && break
        # This is a single paren and there are no open parens, so this isn't an arithmetic expansion
        return 1
        ;;
      '`')
        saved_reply=($reply)
        _zsh_highlight_main_highlighter_highlight_backtick $i
        (( i = REPLY ))
        reply=($saved_reply $reply)
        continue
        ;;
      '$' )
        if [[ $arg[i+1] == $'\x28' ]]; then
          saved_reply=($reply)
          if [[ $arg[i+2] == $'\x28' ]] && _zsh_highlight_main_highlighter_highlight_arithmetic $i; then
            # Arithmetic expansion
            (( i = REPLY ))
            reply=($saved_reply $reply)
            continue
          fi

          (( i += 2 ))
          _zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,end_pos]
          ret=$?
          (( i += REPLY ))
          reply=(
            $saved_reply
            $j $(( start_pos + i )) command-substitution-quoted
            $j $(( j + 2 )) command-substitution-delimiter-quoted
            $reply
          )
          if (( ret == 0 )); then
            reply+=($(( start_pos + i - 1 )) $(( start_pos + i )) command-substitution-delimiter)
          fi
          continue
        else
          continue
        fi
        ;;
      ($histchars[1]) # ! - may be a history expansion
        if [[ $arg[i+1] != ('='|$'\x28'|$'\x7b'|[[:blank:]]) ]]; then
          style=history-expansion
        else
          continue
        fi
        ;;
      *)
        continue
        ;;

    esac
    reply+=($j $k $style)
  done

  if [[ $arg[i] != ')' ]]; then
    # If unclosed, i points past the end
    (( i-- ))
  fi
    style=arithmetic-expansion
  reply=($(( start_pos + $1 - 1)) $(( start_pos + i )) arithmetic-expansion $reply)
  REPLY=$i
}


# Called with a single positional argument.
# Perform filename expansion (tilde expansion) on the argument and set $REPLY to the expanded value.
#
# Does not perform filename generation (globbing).
_zsh_highlight_main_highlighter_expand_path()
{
  (( $# == 1 )) || print -r -- >&2 "zsh-syntax-highlighting: BUG: _zsh_highlight_main_highlighter_expand_path: called without argument"

  # The $~1 syntax normally performs filename generation, but not when it's on the right-hand side of ${x:=y}.
  setopt localoptions nonomatch
  unset REPLY
  : ${REPLY:=${(Q)${~1}}}
}

# -------------------------------------------------------------------------------------------------
# Main highlighter initialization
# -------------------------------------------------------------------------------------------------

_zsh_highlight_main__precmd_hook() {
  # Unset the WARN_NESTED_VAR option, taking care not to error if the option
  # doesn't exist (zsh older than zsh-5.3.1-test-2).
  setopt localoptions
  if eval '[[ -o warnnestedvar ]]' 2>/dev/null; then
    unsetopt warnnestedvar
  fi

  _zsh_highlight_main__command_type_cache=()
}

autoload -Uz add-zsh-hook
if add-zsh-hook precmd _zsh_highlight_main__precmd_hook 2>/dev/null; then
  # Initialize command type cache
  typeset -gA _zsh_highlight_main__command_type_cache
else
  print -r -- >&2 'zsh-syntax-highlighting: Failed to load add-zsh-hook. Some speed optimizations will not be used.'
  # Make sure the cache is unset
  unset _zsh_highlight_main__command_type_cache
fi
typeset -ga ZSH_HIGHLIGHT_DIRS_BLACKLIST
