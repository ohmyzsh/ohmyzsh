# vim: 
hn="$(hostname -s)"

# if we have a color set defined for that host, load it
if [[ -f "$ZSH/lib/powerline/$hn" ]]; then
  . "$ZSH/lib/powerline/$hn"
else

  colours=(22 71 152 32)
  # set colours from array:
  prompt_context_user_fg="${colours[1]}"
  prompt_context_user_bg="${colours[2]}"
  prompt_context_root_fg="${colours[3]}"
  prompt_context_root_bg="${colours[4]}"

fi

