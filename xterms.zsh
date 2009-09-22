# Specific to xterms, such as OS X terminal

if [[ "${TERM}" == xterm* ]]; then
  unset TMOUT

  precmd () {
    print -Pn  "\033]0;%n@%m %~\007"
    #print -Pn "\033]0;%n@%m%#  %~ %l  %w :: %T\a" ## or use this
  }

  preexec () {
    print -Pn "\033]0;%n@%m <$1> %~\007"
    #print -Pn "\033]0;%n@%m%#  <$1>  %~ %l  %w :: %T\a" ## or use this
  }

fi