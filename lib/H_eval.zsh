eval-echo() {
LBUFFER="${LBUFFER}echo \$(( "
RBUFFER=" ))$RBUFFER"
}
zle -N eval-echo
# F1
bindkey "^[[11~" eval-echo

eval-ruby() {
LBUFFER="${LBUFFER}ruby -e \"p "
RBUFFER=" \"$RBUFFER"
}
zle -N eval-ruby
# F2
bindkey "^[[12~" eval-echo
