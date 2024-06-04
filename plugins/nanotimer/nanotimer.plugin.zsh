#!/usr/bin/env zsh

## nanotimer - Oh-My-Zsh plugin
##
## Utilizes the 'preexec' and 'precmd' hooks. Timer is setup during 'preexec', and stopped at
## 'precmd'. This time difference is very accurate, and is displayed in the right prompt.
##
## More information about hooks like 'preexec' and 'precmd', and many others:
## https://zsh.sourceforge.io/Doc/Release/Functions.html#index-hook-functions

## * __exectimer_preexec()
## Executed just after a command has been read and is about to be executed. This hook is used to
## start a high-precision timer before command execution. Additional tasks can be completed in this
## function; for example, update active network interface. By doing that here, it ensures the
## network interface stays updated.
__exectimer_preexec() {
  timer=$(($(date +%s%0N)))
}

## * __exectimer_precmd()
## Executed before each prompt, or in other words, after previous command. Stops the timer from
## 'preexec', and updates rprompt with elapsed time. This is modified for higher precision from the
## following code snippet: https://gist.github.com/knadh/123bca5cfdae8645db750bfb49cb44b0
__exectimer_precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%0N)))
    elapsed=$(($now-$timer))

    # Unset elapsed variables to make below syntax work (work-around to prevent more work)
    unset elns elmcs elms els

    # Depending on digits in nanoseconds, set the elapsed milliseconds, seconds etc.
    # I should document this more later as ZSH syntax is kinda weird sometimes.
    case ${#elapsed} in
      [0-3])
        elns=$elapsed
        ;;
      [4-6])
        elapsed=${elapsed%${elns=${elapsed:(-3):3}}}
        elmcs=$elapsed
        ;;
      [7-9])
        elapsed=${elapsed%${elns=${elapsed:(-3):3}}}
        elapsed=${elapsed%${elmcs=${elapsed:(-3):3}}}
        elms=$elapsed
        ;;
      *)
        elapsed=${elapsed%${elns=${elapsed:(-3):3}}}
        elapsed=${elapsed%${elmcs=${elapsed:(-3):3}}}
        elapsed=${elapsed%${elms=${elapsed:(-3):3}}}
        els=$elapsed
        ;;
    esac

    # Zero values for all, when e.g. under a second execution.
    for v in elns elmcs elms els; do
      [[ ! "${(P)v}" =~ ^[0-9]+$ ]] && read $v <<< $((0))
    done

    # Set right prompt and reset timer.
    export RPROMPT="%(?.%F{195}[%?].%S%B%F{009}[%?]%b%s) %F{215}%B${els}%b%F{250}s %F{192}%B${elms}%b%F{250}ms %F{194}%B${elmcs}%b%F{250}μs %F{231}%B${elns}%b%F{250}ns%{$reset_color%}"

    unset timer
  fi
}

# Add functions to Zsh hooks.
autoload -U add-zsh-hook
add-zsh-hook preexec __exectimer_preexec
add-zsh-hook precmd __exectimer_precmd
