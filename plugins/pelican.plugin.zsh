# -------------------------------------------------------
# Pelican plugin for oh-my-zsh
# author: Yann-Sebastien Tremblay-Johnston (underchemist)
# email: yanns.tremblay@gmail.com
# -------------------------------------------------------
# wrapper script for pelican build and deploy commands
# set to use the make file in the pelican directory
# -------------------------------------------------------

alias pb='make html' # (re)generate the web site
alias pc='make clean' # remove the generated files
alias pbr='make regenerate' # regnerate files upon modification
alias pp='make publish' # generate using publishconf.py
alias pl='make serve' # serve site at http:localhost:8000
alias pd='make devserver' # start/restart develop_server.py
alias psp='make stopserver' # stop local server
alias pgit='make github' # upload to the web site via gh-pages
