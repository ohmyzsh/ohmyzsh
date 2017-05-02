# commands to control local postgres installation
# paths are for osx installation via macports

alias startpost='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias stoppost='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias restartpost='stoppost && sleep 1 && startpost'