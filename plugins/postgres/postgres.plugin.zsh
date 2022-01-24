# Aliases to control Postgres
# Paths noted below are for Postgres installed via Homebrew on OSX
if [[ -d /opt/homebrew/var ]]; then
  local DB_LOCATION_DIR="/opt/homebrew/var/postgres"
else
  local DB_LOCATION_DIR="/usr/local/var/postgres"
fi

alias startpost="pg_ctl -D $DB_LOCATION_DIR -l $DB_LOCATION_DIR/server.log start"
alias stoppost="pg_ctl -D $DB_LOCATION_DIR stop -s -m fast"
alias restartpost="stoppost && sleep 1 && startpost"
alias reloadpost="pg_ctl reload -D $DB_LOCATION_DIR -s"
alias statuspost="pg_ctl status -D $DB_LOCATION_DIR -s"
