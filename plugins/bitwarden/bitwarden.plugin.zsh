# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.

alias bwunlock='export BW_SESSION=`bw unlock --raw`'
alias bwpass='bw --quiet get password test || bwunlock && bw get password'
