typeset -grA __p9k_pb_cmd_skip=(
  '}'         'always'  # handled specially
  '{'         ''
  '{'         ''
  '|'         ''
  '||'        ''
  '&'         ''
  '&&'        ''
  '|&'        ''
  '&!'        ''
  '&|'        ''
  ')'         ''
  '('         ''
  '()'        ''
  '!'         ''
  ';'         ''
  'if'        ''
  'fi'        ''
  'elif'      ''
  'else'      ''
  'then'      ''
  'while'     ''
  'until'     ''
  'do'        ''
  'done'      ''
  'esac'      ''
  'end'       ''
  'coproc'    ''
  'nocorrect' ''
  'noglob'    ''
  'time'      ''
  '[['        '\]\]'
  '(('        '\)\)'
  'case'      '\)|esac'
  ';;'        '\)|esac'
  ';&'        '\)|esac'
  ';|'        '\)|esac'
  'foreach'   '\(*\)'
)

typeset -grA __p9k_pb_precommand=(
  '-'         ''
  'builtin'   ''
  'command'   ''
  'exec'      '-[^a]#[a]'
  'nohup'     ''
  'setsid'    ''
  'eatmydata' ''
  'catchsegv' ''
  'pkexec'    '--user'
  'doas'      '-[^aCu]#[acU]'
  'nice'      '-[^n]#[n]|--adjustment'
  'stdbuf'    '-[^ioe]#[ioe]|--(input|output|error)'
  'sudo'      '-[^aghpuUCcrtT]#[aghpuUCcrtT]|--(close-from|group|host|prompt|role|type|other-user|command-timeout|user)'
  'ssh-agent' '-[^aEPt]#[aEPt]'
  'tabbed'    '-[^gnprtTuU]#[gnprtTuU]'
  'chronic'   ''
  'ifne'      ''
)

typeset -grA __p9k_pb_redirect=(
  '&>'   ''
  '>'    ''
  '>&'   ''
  '<'    ''
  '<&'   ''
  '<>'   ''
  '&>|'  ''
  '>|'   ''
  '&>>'  ''
  '>>'   ''
  '>>&'  ''
  '&>>|' ''
  '>>|'  ''
  '<<<'  ''
)

typeset -grA __p9k_pb_term=(
  '|'  ''
  '||' ''
  ';'  ''
  '&'  ''
  '&&' ''
  '|&' ''
  '&!' ''
  '&|' ''
  ';;' ''
  ';&' ''
  ';|' ''
  '('  ''
  ')'  ''
  '()' ''  # handled specially
  '}'  ''  # handled specially
)

typeset -grA __p9k_pb_term_skip=(
  '('  '\)'
  ';;' '\)|esac'
  ';&' '\)|esac'
  ';|' '\)|esac'
)

# Usage: _p9k_parse_buffer <buffer> [token-limit]
#
# Parses the specified command line buffer and pupulates array P9K_COMMANDS
# with commands from it. Terminates early and returns 1 if there are more
# tokens than the specified limit.
#
# Broken:
#
#   ---------------
#   : $(x)
#   ---------------
#   : `x`
#   ---------------
#   ${x/}
#   ---------------
#   - -- x
#   ---------------
#   command -p -p x
#   ---------------
#   *
#   ---------------
#   x=$y; $x
#   ---------------
#   alias x=y; y
#   ---------------
#   x <<END
#   ; END
#   END
#   ---------------
#   Setup:
#     setopt interactive_comments
#     alias x='#'
#   Punchline:
#     x; y
#   ---------------
#
# More brokenness with non-standard options (ignore_braces, ignore_close_braces, etc.).
function _p9k_parse_buffer() {
  [[ ${2:-0} == <-> ]] || return 2

  local rcquotes
  [[ -o rcquotes ]] && rcquotes=rcquotes

  eval "$__p9k_intro"
  setopt no_nomatch $rcquotes

  typeset -ga P9K_COMMANDS=()

  local -r id='(<->|[[:alpha:]_][[:IDENT:]]#)'
  local -r var="\$$id|\${$id}|\"\$$id\"|\"\${$id}\""

  local -i e ic c=${2:-'1 << 62'}
  local skip n s r state token cmd prev
  local -a aln alp alf v

  if [[ -o interactive_comments ]]; then
    ic=1
    local tokens=(${(Z+C+)1})
  else
    local tokens=(${(z)1})
  fi

  {
    while (( $#tokens )); do
      (( e = $#state ))

      while (( $#tokens == alp[-1] )); do
        aln[-1]=()
        alp[-1]=()
        if (( $#tokens == alf[-1] )); then
          alf[-1]=()
          (( e = 0 ))
        fi
      done

      while (( c-- > 0 )) || return; do
        token=$tokens[1]
        tokens[1]=()
        if (( $+galiases[$token] )); then
          (( $aln[(eI)p$token] )) && break
          s=$galiases[$token]
          n=p$token
        elif (( e )); then
          break
        elif (( $+aliases[$token] )); then
          (( $aln[(eI)p$token] )) && break
          s=$aliases[$token]
          n=p$token
        elif [[ $token == ?*.?* ]] && (( $+saliases[${token##*.}] )); then
          r=${token##*.}
          (( $aln[(eI)s$r] )) && break
          s=${saliases[$r]%% #}
          n=s$r
        else
          break
        fi
        aln+=$n
        alp+=$#tokens
        [[ $s == *' ' ]] && alf+=$#tokens
        (( ic )) && tokens[1,0]=(${(Z+C+)s}) || tokens[1,0]=(${(z)s})
      done

      case $token in
        '<<'(|-))
          state=h
          continue
          ;;
        *('`'|['<>=$']'(')*)
          if [[ $token == ('`'[^'`']##'`'|'"`'[^'`']##'`"'|'$('[^')']##')'|'"$('[^')']##')"'|['<>=']'('[^')']##')') ]]; then
            s=${${token##('"'|)(['$<>']|)?}%%?('"'|)}
            (( ic )) && tokens+=(';' ${(Z+C+)s}) || tokens+=(';' ${(z)s})
          fi
          ;;
      esac

      case $state in
        *r)
          state[-1]=
          continue
          ;;
        a)
          if [[ $token == $skip ]]; then
            if [[ $token == '{' ]]; then
              P9K_COMMANDS+=$cmd
              cmd=
              state=
            else
              skip='{'
            fi
            continue
          else
            state=t
          fi
          ;&  # fall through
        t|p*)
          if (( $+__p9k_pb_term[$token] )); then
            if [[ $token == '()' ]]; then
              state=
            else
              P9K_COMMANDS+=$cmd
              if [[ $token == '}' ]]; then
                state=a
                skip=always
              else
                skip=$__p9k_pb_term_skip[$token]
                state=${skip:+s}
              fi
            fi
            cmd=
            continue
          elif [[ $state == t ]]; then
            continue
          elif [[ $state == *x ]]; then
            if (( $+__p9k_pb_redirect[$token] )); then
              prev=
              state[-1]=r
              continue
            else
              state[-1]=
            fi
          fi
          ;;
        s)
          if [[ $token == $~skip ]]; then
            state=
          fi
          continue
          ;;
        h)
          while (( $#tokens )); do
            (( e = ${tokens[(i)${(Q)token}]} ))
            if [[ $tokens[e-1] == ';' && $tokens[e+1] == ';' ]]; then
              tokens[1,e]=()
              break
            else
              tokens[1,e]=()
            fi
          done
          while (( $#alp && alp[-1] >= $#tokens )); do
            aln[-1]=()
            alp[-1]=()
          done
          state=t
          continue
          ;;
      esac

      if (( $+__p9k_pb_redirect[${token#<0-255>}] )); then
        state+=r
        continue
      fi

      if [[ $token == *'$'* ]]; then
        if [[ $token == $~var ]]; then
          n=${${token##[^[:IDENT:]]}%%[^[:IDENT:]]}
          [[ $token == *'"' ]] && v=("${(P)n}") || v=(${(P)n})
          tokens[1,0]=(${(@qq)v})
          continue
        fi
      fi

      case $state in
        '')
          if (( $+__p9k_pb_cmd_skip[$token] )); then
            skip=$__p9k_pb_cmd_skip[$token]
            [[ $token == '}' ]] && state=a || state=${skip:+s}
            continue
          fi
          if [[ $token == *=* ]]; then
            v=${(S)token/#(<->|([[:alpha:]_][[:IDENT:]]#(|'['*[^\\](\\\\)#']')))(|'+')=}
            if (( $#v < $#token )); then
              if [[ $v == '(' ]]; then
                state=s
                skip='\)'
              fi
              continue
            fi
          fi
          : ${token::=${(Q)${~token}}}
          ;;
        p2)
          if [[ -n $prev ]]; then
            prev=
          else
            : ${token::=${(Q)${~token}}}
            if [[ $token == '{'$~id'}' ]]; then
              state=p2x
              prev=$token
            else
              state=p
            fi
            continue
          fi
          ;&  # fall through
        p)
          if [[ -n $prev ]]; then
            token=$prev
            prev=
          else
            : ${token::=${(Q)${~token}}}
            case $token in
              '{'$~id'}') prev=$token; state=px; continue;;
              [^-]*)                                     ;;
              --)                      state=p1; continue;;
              $~skip)                  state=p2; continue;;
              *)                                 continue;;
            esac
          fi
          ;;
        p1)
          if [[ -n $prev ]]; then
            token=$prev
            prev=
          else
            : ${token::=${(Q)${~token}}}
            if [[ $token == '{'$~id'}' ]]; then
              state=p1x
              prev=$token
              continue
            fi
          fi
          ;;
      esac

      if (( $+__p9k_pb_precommand[$token] )); then
        prev=
        state=p
        skip=$__p9k_pb_precommand[$token]
        cmd+=$token$'\0'
      else
        state=t
        [[ $token == ('(('*'))'|'`'*'`'|'$'*|['<>=']'('*')'|*$'\0'*) ]] || cmd+=$token$'\0'
      fi
    done
  } always {
    [[ $state == (px|p1x) ]] && cmd+=$prev
    P9K_COMMANDS+=$cmd
    P9K_COMMANDS=(${(u)P9K_COMMANDS%$'\0'})
  }
}
