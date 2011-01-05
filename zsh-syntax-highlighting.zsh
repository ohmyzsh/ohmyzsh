#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et

# Copyleft 2011 zsh-syntax-highlighting contributors
# http://github.com/nicoulaj/zsh-syntax-highlighting
# All wrongs reserved.

# Token types styles.
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
  default                       'none'
  isearch                       'fg=magenta,standout'
  special                       'fg=magenta,standout'
  unknown-token                 'fg=red,bold'
  reserved-word                 'fg=yellow'
  alias                         'fg=green'
  builtin                       'fg=green'
  function                      'fg=green'
  command                       'fg=green'
  path                          'underline'
  globbing                      'fg=blue'
  history-expansion             'fg=blue'
  single-hyphen-option          'none'
  double-hyphen-option          'none'
  back-quoted-argument          'none'
  single-quoted-argument        'fg=yellow'
  double-quoted-argument        'fg=yellow'
  dollar-double-quoted-argument 'fg=cyan'
  back-double-quoted-argument   'fg=cyan'
)

# Tokens that are always followed by a command.
ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS=(
  '|'
  '||'
  ';'
  '&'
  '&&'
  'sudo'
  'start'
  'time'
  'strace'
  'noglob'
  'nocorrect'
  'command'
  'builtin'
  'whence'
  'which'
  'where'
  'whereis'
)

# ZLE events that trigger an update of the highlighting.
ZSH_HIGHLIGHT_ZLE_UPDATE_EVENTS=(
  accept-and-hold
  accept-and-infer-next-history
# accept-and-menu-complete
  accept-line
  accept-line-and-down-history
  argument-base
  auto-suffix-remove
  auto-suffix-retain
  backward-char
  backward-delete-char
  backward-delete-word
  backward-kill-line
  backward-kill-word
  backward-kill-word-match
  backward-word
  backward-word-match
  beep
  beginning-of-buffer-or-history
  beginning-of-history
  beginning-of-line
  beginning-of-line-hist
  capitalize-word
  capitalize-word-match
  clear-screen
  complete-word
  copy-earlier-word
  copy-prev-shell-word
  copy-prev-word
  copy-region-as-kill
  cycle-completion-positions
  delete-char
  delete-char-or-list
  delete-to-char
  delete-whole-word-match
  delete-word
  describe-key-briefly
  digit-argument
  down-case-word
  down-case-word-match
  down-history
  down-line-or-beginning-search
  down-line-or-history
  down-line-or-search
  edit-command-line
  emacs-backward-word
  emacs-forward-word
  end-of-buffer-or-history
  end-of-history
  end-of-line
  end-of-line-hist
  end-of-list
  exchange-point-and-mark
  execute-last-named-cmd
  execute-named-cmd
  expand-cmd-path
  expand-history
  expand-or-complete
  expand-or-complete-prefix
  expand-word
  forward-char
  forward-word
  forward-word-match
  get-line
  gosmacs-transpose-chars
  history-beginning-search-backward
  history-beginning-search-backward-end
  history-beginning-search-forward
  history-beginning-search-forward-end
  history-beginning-search-menu
  history-incremental-pattern-search-backward
  history-incremental-pattern-search-forward
  history-incremental-search-backward
  history-incremental-search-forward
  history-pattern-search
  history-pattern-search-backward
  history-pattern-search-forward
  history-search-backward
  history-search-forward
  incarg
# incremental-complete-word
  infer-next-history
  insert-composed-char
  insert-files
  insert-last-word
  insert-unicode-char
  kill-buffer
  kill-line
  kill-region
  kill-whole-line
  kill-word
  kill-word-match
  list-choices
  list-expand
  magic-space
  match-word-context
  match-words-by-style
  menu-complete
  menu-expand-or-complete
  menu-select
  modify-current-argument
  narrow-to-region
  narrow-to-region-invisible
  neg-argument
  overwrite-mode
  pound-insert
  predict-off
  predict-on
  push-input
  push-line
  push-line-or-edit
  quote-line
  quote-region
  quoted-insert
  read-command
  read-from-minibuffer
  recursive-edit
  redisplay
  redo
  replace-pattern
  replace-string
  replace-string-again
  reset-prompt
  reverse-menu-complete
  run-help
  select-word-style
  self-insert
  self-insert-unmeta
  send-break
  set-mark-command
  smart-insert-last-word
  spell-word
  split-shell-arguments
  transpose-chars
  transpose-words
  transpose-words-match
  undefined-key
  undo
  universal-argument
  up-case-word
  up-case-word-match
  up-history
  up-line-or-beginning-search
  up-line-or-history
  up-line-or-search
  vi-add-eol
  vi-add-next
  vi-backward-blank-word
  vi-backward-char
  vi-backward-delete-char
  vi-backward-kill-word
  vi-backward-word
  vi-beginning-of-line
  vi-caps-lock-panic
  vi-change
  vi-change-eol
  vi-change-whole-line
  vi-cmd-mode
  vi-delete
  vi-delete-char
  vi-digit-or-beginning-of-line
  vi-down-line-or-history
  vi-end-of-line
  vi-fetch-history
  vi-find-next-char
  vi-find-next-char-skip
  vi-find-prev-char
  vi-find-prev-char-skip
  vi-first-non-blank
  vi-forward-blank-word
  vi-forward-blank-word-end
  vi-forward-char
  vi-forward-word
  vi-forward-word-end
  vi-goto-column
  vi-goto-mark
  vi-goto-mark-line
  vi-history-search-backward
  vi-history-search-forward
  vi-indent
  vi-insert
  vi-insert-bol
  vi-join
  vi-kill-eol
  vi-kill-line
  vi-match-bracket
  vi-open-line-above
  vi-open-line-below
  vi-oper-swap-case
  vi-pound-insert
  vi-put-after
  vi-put-before
  vi-quoted-insert
  vi-repeat-change
  vi-repeat-find
  vi-repeat-search
  vi-replace
  vi-replace-chars
  vi-rev-repeat-find
  vi-rev-repeat-search
  vi-set-buffer
  vi-set-mark
  vi-substitute
  vi-swap-case
  vi-undo-change
  vi-unindent
  vi-up-line-or-history
  vi-yank
  vi-yank-eol
  vi-yank-whole-line
  what-cursor-position
  where-is
  which-command
  yank
  yank-pop
  zap-to-char
)

# ZLE highlight types.
zle_highlight=(
  special:$ZSH_HIGHLIGHT_STYLES[special]
  isearch:$ZSH_HIGHLIGHT_STYLES[isearch]
)

# Check if the argument is a path.
_zsh_check-path() {
  [[ -z $arg ]] && return 1
  [[ -e $arg ]] && return 0
  [[ ! -e ${arg:h} ]] && return 1
  [[ ${#BUFFER} == $end_pos && -n $(print $arg*(N)) ]] && return 0
  return 1
}

# Highlight special chars inside double-quoted strings
_zsh_highlight-string() {
  setopt localoptions noksharrays
  local i j k style
  # Starting quote is at 1, so start parsing at offset 2 in the string.
  for (( i = 2 ; i < end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      '$')  style=$ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument];;
      "\\") style=$ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]
            (( k += 1 )) # Color following char too.
            (( i += 1 )) # Skip parsing the escaped char.
            ;;
      *)    continue;;
    esac
    region_highlight+=("$j $k $style")
  done
}

# Recolorize the current ZLE buffer.
_zsh_highlight-zle-buffer() {
  # Avoid doing the same work over and over
  [[ ${ZSH_PRIOR_HIGHLIGHTED_BUFFER:-} == $BUFFER ]] && return
  ZSH_PRIOR_HIGHLIGHTED_BUFFER=$BUFFER

  setopt localoptions extendedglob bareglobqual
  local new_expression=true
  local start_pos=0
  local highlight_glob=true
  local end_pos arg style
  region_highlight=()
  for arg in ${(z)BUFFER}; do
    local substr_color=0
    [[ $start_pos -eq 0 && $arg = 'noglob' ]] && highlight_glob=false
    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]##[[:space:]]#}}))
    ((end_pos=$start_pos+${#arg}))
    if $new_expression; then
      new_expression=false
      res=$(LC_ALL=C builtin type -w $arg 2>/dev/null)
      case $res in
        *': reserved')  style=$ZSH_HIGHLIGHT_STYLES[reserved-word];;
        *': alias')     style=$ZSH_HIGHLIGHT_STYLES[alias]
                        local aliased_command="${"$(alias $arg)"#*=}"
                        if [[ ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)$aliased_command]:-}:+yes} = 'yes' && ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)$arg]:-}:+yes} != 'yes' ]]; then
                          ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS+=($arg)
                        fi
                        ;;
        *': builtin')   style=$ZSH_HIGHLIGHT_STYLES[builtin];;
        *': function')  style=$ZSH_HIGHLIGHT_STYLES[function];;
        *': command')   style=$ZSH_HIGHLIGHT_STYLES[command];;
        *)              if _zsh_check-path; then
                          style=$ZSH_HIGHLIGHT_STYLES[path]
                        elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                          style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                        else
                          style=$ZSH_HIGHLIGHT_STYLES[unknown-token]
                        fi
                        ;;
      esac
    else
      case $arg in
        '--'*)   style=$ZSH_HIGHLIGHT_STYLES[double-hyphen-option];;
        '-'*)    style=$ZSH_HIGHLIGHT_STYLES[single-hyphen-option];;
        "'"*"'") style=$ZSH_HIGHLIGHT_STYLES[single-quoted-argument];;
        '"'*'"') style=$ZSH_HIGHLIGHT_STYLES[double-quoted-argument]
                 region_highlight+=("$start_pos $end_pos $style")
                 _zsh_highlight-string
                 substr_color=1
                 ;;
        '`'*'`') style=$ZSH_HIGHLIGHT_STYLES[back-quoted-argument];;
        *"*"*)   $highlight_glob && style=$ZSH_HIGHLIGHT_STYLES[globbing] || style=$ZSH_HIGHLIGHT_STYLES[default];;
        *)       if _zsh_check-path; then
                   style=$ZSH_HIGHLIGHT_STYLES[path]
                 elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                 else
                   style=$ZSH_HIGHLIGHT_STYLES[default]
                 fi
                 ;;
      esac
    fi
    [[ $substr_color = 0 ]] && region_highlight+=("$start_pos $end_pos $style")
    [[ ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]:-}:+yes} = 'yes' ]] && new_expression=true
    start_pos=$end_pos
  done
}

# Special treatment for completion/expansion events:
# For each *complete* function, we create a widget which mimics the original
# and use this orig-* version inside the new colorized zle function (the dot
# idiom used for all others doesn't work right for these functions for some
# reason).  You can see the default setup using "zle -l -L".

# Bind ZLE events to highlighting function.
for f in $ZSH_HIGHLIGHT_ZLE_UPDATE_EVENTS; do
  case $f in
    *complete*)
      eval "zle -C orig-$f .$f _main_complete ; $f() { builtin zle orig-$f && _zsh_highlight-zle-buffer } ; zle -N $f"
      ;;
    *)
      eval "$f() { builtin zle .$f && _zsh_highlight-zle-buffer } ; zle -N $f"
      ;;
  esac
done


