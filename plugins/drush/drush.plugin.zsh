# Functions
function dren() {
  drush en "$@" -y
}

function dris() {
  drush pm-disable "$@" -y
}

function drpu() {
  drush pm-uninstall "$@" -y
}

function drf() {
  if [[ -z "$1" ]] then
    drush core-config
  else
    drush core-config --choice=$1
  fi
}

function drfi() {
  case "$1" in
  fields) drush field-info fields ;;
  types) drush field-info types ;;
  *) drush field-info ;;
  esac
}

function drnew() {
  (
    cd
    echo "Website's name: "
    read WEBSITE_NAME

    HOST=http://$(hostname -i)/

    if [[ $WEBSITE_NAME == "" ]] then
      MINUTES=$(date +%M:%S)
      WEBSITE_NAME="Drupal-$MINUTES"
      echo "Your website will be named: $WEBSITE_NAME"
    fi

    drush dl drupal --drupal-project-rename=$WEBSITE_NAME

    echo "Type your localhost directory: (Leave empty for /var/www/html/)"
    read DIRECTORY

    if [[ $DIRECTORY == "" ]] then
      DIRECTORY="/var/www/html/"
    fi

    echo "Moving to $DIRECTORY$WEBSITE_NAME"
    sudo mv $WEBSITE_NAME $DIRECTORY
    cd $DIRECTORY$WEBSITE_NAME

    echo "Database's user: "
    read DATABASE_USR
    echo "Database's password: "
    read -s DATABASE_PWD
    echo "Database's name for your project: "
    read DATABASE

    DB_URL="mysql://$DATABASE_USR:$DATABASE_PWD@localhost/$DATABASE"
    drush site-install standard --db-url=$DB_URL --site-name=$WEBSITE_NAME

    open_command $HOST$WEBSITE_NAME
    echo "Done"
  )
}

# Aliases
alias dr="drush"
alias drca="drush cc all" # Deprecated for Drush 8
alias drcb="drush cc block" # Deprecated for Drush 8
alias drcex="drush config:export -y"
alias drcg="drush cc registry" # Deprecated for Drush 8
alias drcim="drush config:import -y"
alias drcj="drush cc css-js"
alias drcm="drush cc menu"
alias drcml="drush cc module-list"
alias drcr="drush core-cron"
alias drct="drush cc theme-registry"
alias drcv="drush cc views"
alias drdmp="drush sql-dump --ordered-dump --result-file=dump.sql"
alias drf="drush features"
alias drfr="drush features-revert -y"
alias drfra="drush features-revert-all"
alias drfu="drush features-update -y"
alias drif="drush image-flush --all"
alias drpm="drush pm-list --type=module"
alias drst="drush core-status"
alias druli="drush user:login"
alias drup="drush updatedb"
alias drups="drush updatedb-status"
alias drv="drush version"
alias drvd="drush variable-del"
alias drvg="drush variable-get"
alias drvs="drush variable-set"
alias drws="drush watchdog:show"
alias drwse="drush watchdog:show --extended"
alias drwst="drush watchdog:tail"

# Enable drush autocomplete support
autoload bashcompinit
bashcompinit
source $(dirname $0)/drush.complete.sh
