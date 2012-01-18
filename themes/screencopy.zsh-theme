#
# theme for drag copying the terminal screen

# these functions may be declared in "ZSH/custom" directory
function switch-to-screencopy {
  ZSH_THEME=screencopy source $ZSH/oh-my-zsh.sh
}
function switch-to-normal {
  source $ZSH/oh-my-zsh.sh
}

# set non-intrusive prompt for copying
PS1=' > '
PS2='   '
PS3=''
PS4=''
RPS1=''
RPS2=''
