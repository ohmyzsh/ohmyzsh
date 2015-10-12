# Add yourself some shortcuts to projects you often work on
# Example:
#
# brainstormr=/Users/robbyrussell/Projects/development/planetargon/brainstormr
#
<<<<<<< HEAD
alias p='tail -1 /home/pdavis/notes.txt | pbcopy'
alias pbcopy='xsel --clipboard --input'
alias rosh='ssh pdavis-admin@opsware.discovery.com -p 2222'
alias console='cu -t -l /dev/ttyUSB0 -s 115200'
=======
[[ $TERM != "screen" ]] && exec tmux
>>>>>>> 2877573c110ffc587f156ed6601ac732f647466a
