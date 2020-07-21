_cb-yank() {
  AA=$(clippaste 2>/dev/null) && CUTBUFFER="$AA"
  zle yank
}
_cb-kill-line() {
  zle kill-line
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}
_cb-kill-whole-line() {
  zle kill-whole-line
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}
_cb-kill-word() {
  zle kill-word
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}
_cb-backward-kill-word() {
  zle backward-kill-word
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}
_cb-copy-region-as-kill() {
  ## https://unix.stackexchange.com/questions/19947/
  zle copy-region-as-kill
  zle set-mark-command -n -1
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}

zle -N _cb-yank
zle -N _cb-kill-line
zle -N _cb-kill-whole-line
zle -N _cb-kill-word
zle -N _cb-backward-kill-word
zle -N _cb-copy-region-as-kill

bindkey '^y'   _cb-yank
bindkey '^k'   _cb-kill-line
bindkey '^u'   _cb-kill-whole-line
bindkey '\ed'  _cb-kill-word
bindkey '\e^?' _cb-backward-kill-word
bindkey '\ew'  _cb-copy-region-as-kill
