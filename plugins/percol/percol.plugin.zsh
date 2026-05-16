(( ${+commands[percol]} )) || return

function percol_select_history() {
  # print history in reverse order (from -1 (latest) to 1 (oldest))
  BUFFER=$(fc -l -n -1 1 | percol --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle -R -c
}
zle -N percol_select_history
bindkey -M emacs '^R' percol_select_history
bindkey -M viins '^R' percol_select_history
bindkey -M vicmd '^R' percol_select_history

if (( ${+functions[marks]} )); then
  function percol_select_marks() {
    # parse directory from marks output (markname -> path) and quote if necessary
    BUFFER=${(q)"$(marks | percol --query "$LBUFFER")"##*-> }
    CURSOR=$#BUFFER
    zle -R -c
  }
  zle -N percol_select_marks
  bindkey -M emacs '^B' percol_select_marks
  bindkey -M viins '^B' percol_select_marks
  bindkey -M vicmd '^B' percol_select_marks
fi
