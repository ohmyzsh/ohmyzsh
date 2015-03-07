# Aliases to control Postgres
# Paths noted below are for Postgres installed via Homebrew on OSX

alias startpost='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias stoppost='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias restartpost='stoppost && sleep 1 && startpost'
alias reloadpost='pg_ctl reload -D /usr/local/var/postgres -s'
alias statuspost='pg_ctl status -D /usr/local/var/postgres -s'