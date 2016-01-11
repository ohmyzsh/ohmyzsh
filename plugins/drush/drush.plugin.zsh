# Drush support.

function dren() {
  drush en $@ -y
}

function dris() {
  drush pm-disable $@ -y
}

function drpu() {
  drush pm-uninstall $@ -y
}

function drf() {
  if [[ $1 == "" ]] then
    drush core-config
  else
    drush core-config --choice=$1
  fi
}

function drfi() {
  if [[ $1 == "fields" ]]; then
    drush field-info fields
  elif [[ $1 == "types" ]]; then
    drush field-info types
  else
    drush field-info
  fi
}

function drnew() {

  cd ~
  echo "Website's name: "
  read WEBSITE_NAME

  HOST=http://$(hostname -i)/

  if [[ $WEBSITE_NAME == "" ]] then
    MINUTES=$(date +%M:%S)
    WEBSITE_NAME="Drupal-$MINUTES"
    echo "Your website will be named: $WEBSITE_NAME"
  fi

  drush dl drupal --drupal-project-rename=$WEBSITE_NAME

  echo "Moving to /var/www"
  mv $WEBSITE_NAME /var/www
  cd /var/www/$WEBSITE_NAME

  echo "Database's user: "
  read DATABASE_USR
  echo "Database's password: "
  read -s DATABASE_PWD
  echo "Database's name: "
  read DATABASE

  drush site-install standard --db-url="mysql://$DATABASE_USR:$DATABASE_PWD@localhost/$DATABASE" --site-name=$WEBSITE_NAME

  open_command $HOST$WEBSITE_NAME
  echo "Done"

}

# Aliases, sorted alphabetically.
alias dr="drush"
alias drca="drush cc all" # Deprecated for Drush 8
alias drcb="drush cc block" # Deprecated for Drush 8
alias drcg="drush cc registry" # Deprecated for Drush 8
alias drcj="drush cc css-js"
alias drcm="drush cc menu"
alias drcml="drush cc module-list"
alias drcr="drush core-cron"
alias drct="drush cc theme-registry"
alias drcv="drush cc views"
alias drdmp="drush sql-dump --ordered-dump --result-file=dump.sql"
alias drf="drush features"
alias drfr="drush features-revert -y"
alias drfu="drush features-update -y"
alias drfra="drush features-revert-all"
alias drif="drush image-flush --all"
alias drpm="drush pm-list --type=module"
alias drst="drush core-status"
alias drup="drush updatedb"
alias drups="drush updatedb-status"
alias drv="drush version"

# Enable drush autocomplete support
autoload bashcompinit
bashcompinit
source $(dirname $0)/drush.complete.sh
