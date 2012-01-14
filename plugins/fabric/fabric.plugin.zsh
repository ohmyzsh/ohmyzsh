#!zsh
# 
# Installation
# ------------
# 
# To achieve fabfile completion nirvana:
# 
#   Copy this file somewhere (e.g. ~/.fab-comletion.zsh) and put the following line in your .zshrc:
# 
#        source ~/.fab-comletion.zsh
#
#    Or, use this file as a oh-my-zsh plugin.
#

_fab_list() {
	reply=(`fab --shortlist`) 
}
compctl -K _fab_list fab

