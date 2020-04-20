alias bwunlock='export BW_SESSION=`bw unlock --raw`'
alias bwpass='bw --quiet sync || bwunlock && bw get password'
