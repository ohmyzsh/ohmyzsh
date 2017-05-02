typeset -F -Z1 SECONDS

cdpath=( . /home/mueller/bachelor/ /home/mueller/bachelor/code/blocks/ofdm_radar / /home/mueller )
alias debug="gdb --args"
alias grc="gnuradio-companion"

note_remind=0
note_ignore="yes"
note_command="?"
[ -n "$SSH_CLIENT" ] &&  PROMPT="#%!|%(!.%B%{$fg[red]%}%n@%U%m%u>%{$reset_color%}%b.%{$fg[green]%}%n@%U%m%u>%{$reset_color%})"|| PROMPT="#%!|%(!.%B%{$fg[red]%}%n@%U%m%u>%{$reset_color%}%b.%{$fg[green]%}%n>%{$reset_color%})" 
RPROMPT="[%{$fg[green]%}%/%{$reset_color%}]"
function title {
  if [[ $TERM == "screen" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\

    print -nR $'\033]0;'$2$'\a'
  elif [[ $TERM == "xterm" || $TERM == "rxvt" ]]; then
    # Use this one instead for XTerms:
    print -nR $'\033]0;'$*$'\a'
  fi
}
  
function precmd {
  title zsh "$PWD"
    local -i xx
    if [ "x$TTY" != "x" ]; then
        if [ "x$note_ignore" = "x" ]; then
            note_ignore="yes"
			xx=$((($SECONDS-$note_remind)*1000))
			RPROMPT="[%!:%(?.%?.%{$fg[red]%}%B%?%b%{$reset_color%}):${xx}ms:%/]"
        fi
    fi
}
  
function preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  title $cmd[1]:t "$cmd[2,-1]"
    if [ "x$TTY" != "x" ]; then
        note_remind="$SECONDS"
        note_ignore=""
        note_command="$2"
    fi
}
