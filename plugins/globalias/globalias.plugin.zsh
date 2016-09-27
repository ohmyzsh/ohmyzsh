globalias() {
   zle _expand_alias
   zle expand-word
   zle self-insert
}
zle -N globalias
bindkey -e " " globalias
bindkey -v " " globalias
bindkey -e "^ " magic-space           # control-space to bypass completion
bindkey -v "^ " magic-space
bindkey -M isearch " " magic-space # normal space during searches
