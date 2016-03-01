reverse-word-delete() {
  RBUFFER=$(echo "$RBUFFER" | sed -e "s/^\W*\w*//")
}

zle -N reverse-word-delete
# Defined shortcut keys: [Esc] [Esc]
bindkey '3~' reverse-word-delete
