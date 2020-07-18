_kc-yank() {
  AA=$(clippaste 2>/dev/null) && CUTBUFFER="$AA"
  zle yank
}
_kc-kill-line() {
  zle kill-line
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}
_kc-kill-whole-line() {
  zle kill-whole-line
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}
_kc-kill-word() {
  zle kill-word
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}
_kc-backward-kill-word() {
  zle backward-kill-word
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}
_kc-copy-region-as-kill() {
  ## https://unix.stackexchange.com/questions/19947/
  zle copy-region-as-kill
  zle set-mark-command -n -1
  printf "%s" "$CUTBUFFER" | clipcopy 2>/dev/null
}

zle -N _kc-yank
zle -N _kc-kill-line
zle -N _kc-kill-whole-line
zle -N _kc-kill-word
zle -N _kc-backward-kill-word
zle -N _kc-copy-region-as-kill

bindkey '^y'   _kc-yank
bindkey '^k'   _kc-kill-line
bindkey '^u'   _kc-kill-whole-line
bindkey '\ed'  _kc-kill-word
bindkey '\e^?' _kc-backward-kill-word
bindkey '\ew'  _kc-copy-region-as-kill
