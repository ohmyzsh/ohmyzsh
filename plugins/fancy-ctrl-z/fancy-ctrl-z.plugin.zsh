# Use Ctrl-Z to switch back to Vim
# I frequently need to execute random command in my shell. To achieve it I pause 
# Vim by pressing Ctrl-z, type command and press fg<Enter> to switch back to Vim.
# The fg part really hurt sme. I just wanted to hit Ctrl-z once again to get back 
# to Vim. I could not find a solution, so I developed one on my own that 
# works wonderfully with ZSH
#
# Source: http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

