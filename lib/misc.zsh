autoload -Uz is-at-least

# *-magic is known buggy in some versions; disable if so
if [[ $DISABLE_MAGIC_FUNCTIONS != true ]]; then
  for d in $fpath; do
    if [[ -e "$d/url-quote-magic" ]]; then
      if is-at-least 5.1; then
        # OHMYZSH-13881: install bracketed-paste-magic only if nothing else is
        # available. To run the `self-insert` widgets over pasted text it
        # replays the paste keystroke by keystroke inside a temporary history
        # file (`fc -p -a /dev/null 0 0`) on an emptied line buffer, then pops
        # that file (`fc -P`) and rolls the replay back with `zle .undo`.
        # Pushing and popping a history stack while ZLE is active leaves the
        # line and undo buffers inconsistent — zsh then segfaults in
        # setlastline() on the next undo:
        # https://www.zsh.org/mla/workers/2026/msg00830.html
        # Undo is bound by default in the emacs keymap (`^_`, `^X^U`), so
        # pasting something and then pressing Ctrl+/ is enough to lose the
        # session. Upstream reproduced it going back to zsh 5.3 and it is still
        # in the latest release, 5.9.2: the fix
        # (https://www.zsh.org/mla/workers/2026/msg00832.html) is only in git
        # master, so whether a build is safe depends on the OS or distribution
        # carrying the patch — one installed from source, or from a QNX package,
        # does not have it. bracketed-paste-url-magic (shipped since zsh 5.2)
        # quotes pasted URLs without touching the history stack or undo, which
        # is all these magic functions are wanted for, so prefer it and fall
        # back to bracketed-paste-magic only on older zsh.
        _omz_paste_magic=bracketed-paste-magic
        for _omz_paste_dir in $fpath; do
          if [[ -e "$_omz_paste_dir/bracketed-paste-url-magic" ]]; then
            _omz_paste_magic=bracketed-paste-url-magic
            break
          fi
        done
        autoload -Uz $_omz_paste_magic
        zle -N bracketed-paste $_omz_paste_magic
        unset _omz_paste_dir _omz_paste_magic
      fi
      autoload -Uz url-quote-magic
      zle -N self-insert url-quote-magic
      break
    fi
  done
fi

setopt multios              # enable redirect to multiple streams: echo >file1 >file2
setopt long_list_jobs       # show long list format job notifications
setopt interactivecomments  # recognize comments

# define pager depending on what is available (less or more)
if (( ${+commands[less]} )); then
  env_default 'PAGER' 'less'
  env_default 'LESS' '-R'
elif (( ${+commands[more]} )); then
  env_default 'PAGER' 'more'
fi

## super user alias
alias _='sudo '

## more intelligent acking for ubuntu users and no alias for users without ack
if (( $+commands[ack-grep] )); then
  alias afind='ack-grep -il'
elif (( $+commands[ack] )); then
  alias afind='ack -il'
fi
