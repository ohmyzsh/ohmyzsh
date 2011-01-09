# Remove aliases we don't want which are defined in oh-my-zsh/lib and activated plugins {{{1
unalias pu
unalias po
unalias ...
unalias -- -
unalias _
unalias lsa
unalias l
unalias ll
unalias sl
unalias heroku
unalias ebuild
unalias hpodder
unalias ..
unalias 1
unalias 2
unalias 3
unalias 4
unalias 5
unalias 6
unalias 7
unalias 8
unalias 9
unalias cd..
unalias cd...
unalias cd....
unalias cd.....
unalias cd/
unalias gist
unalias md
unalias mysql
unalias rd
unalias run-help

# Also remove defined functions we dont want {{{1
unfunction cd
unfunction mcd

# Add our own aliases {{{1
alias WINCH='kill -WINCH $$'
alias bash='env XTERM_LEVEL=$((XTERM_LEVEL+1)) bash'
alias bc='bc -l'
alias grep='nocorrect grep --color'
alias ls='ls -GFh'
alias s=sudo
alias svnkeywords="svn propset svn:keywords 'Author HeadURL Id Revision URL Date'"
alias today='date +%Y/%m/%d'
alias afind='ack -il'
alias dirs='dirs -v'
alias rm='nocorrect rm'
alias rmdir='nocorrect rmdir'
alias history='fc -dl 1'
# vim: ft=sh fdm=marker
