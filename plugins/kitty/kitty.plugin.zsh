#####################################################
# Kitty plugin for oh-my-zsh                        #
#####################################################

# kssh
# Use this when your terminfo isn't recognized on remote hosts.
# See: https://sw.kovidgoyal.net/kitty/faq/#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer
alias kssh="kitty +kitten ssh"
# Use this if kssh fails
alias kssh-slow="infocmp -a xterm-kitty | ssh myserver tic -x -o \~/.terminfo /dev/stdin"

# Change the colour theme
alias kitty-theme="kitty +kitten themes"
