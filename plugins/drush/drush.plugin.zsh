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
  if [[ $1 == 'fields' ]]; then
    drush field-info fields
  elif [[ $1 == 'types' ]]; then
  else
    drush field-info
  fi
}

# Aliases, sorted alphabetically.
alias drcb="drush cc block"
alias drca="drush cc all"
alias drcg="drush cc registry"
alias drcj="drush cc css-js"
alias drcm="drush cc menu"
alias drcml="drush cc module-list"
alias drcr="drush core-cron"
alias drct="drush cc theme-registry"
alias drcv="drush cc views"
alias drpm="drush pm-list --type=module"
alias drst="drush core-status"
alias drup="drush updatedb"
alias drups="drush updatedb-status"
alias drv="drush version"
alias drif="drush image-flush --all"
