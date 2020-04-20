alias bwunlock='export BW_SESSION=`bw unlock --raw`'
alias bwpass='bw --quiet --nointeraction sync || bwunlock && bw get password'
