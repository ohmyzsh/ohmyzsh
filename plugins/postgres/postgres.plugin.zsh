# Aliases to stop, start and restart Postgres
# Paths noted below are for Postgress installed via Homebrew on OSX

alias startpost='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias stoppost='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias restartpost='stoppost && sleep 1 && startpost'