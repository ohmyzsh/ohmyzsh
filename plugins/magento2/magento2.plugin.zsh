#!/usr/bin/env zsh

# Oh My Zsh plugin for Magento 2

# Basic settings and variables
export MAGENTO_ROOT=${MAGENTO_ROOT:-$(pwd)}

# Function to determine the Magento root directory
function _get_magento_root() {
  local dir=$PWD
  while [[ $dir != "/" ]]; do
    if [[ -f "$dir/app/etc/env.php" || (-f "$dir/composer.json" && -d "$dir/vendor/magento") ]]; then
      echo $dir
      return 0
    fi
    dir=${dir:h}
  done
  echo $MAGENTO_ROOT
}

# Set Magento root
function mg-set-root() {
  export MAGENTO_ROOT=$(pwd)
  echo "Magento root set to: $MAGENTO_ROOT"
}

# Navigate to Magento root directory
function mg-cd() {
  local root=$(_get_magento_root)
  cd $root
  echo "Changed to Magento directory: $root"
}

# Aliases for console commands
alias m2="php -d memory_limit=-1 bin/magento"
alias m2cc="m2 cache:clean"
alias m2cf="m2 cache:flush"
alias m2st="m2 setup:upgrade && m2 setup:di:compile && m2 setup:static-content:deploy -f"
alias m2setup="m2 setup:upgrade"
alias m2dicom="m2 setup:di:compile"
alias m2deploy="m2 setup:static-content:deploy -f"
alias m2mode="m2 deploy:mode:show"
alias m2dev="m2 deploy:mode:set developer"
alias m2prod="m2 deploy:mode:set production"
alias m2maint="m2 maintenance:status"
alias m2mainton="m2 maintenance:enable"
alias m2maintoff="m2 maintenance:disable"
alias m2module="m2 module:status"
alias m2mod="m2 module:status"
alias m2enable="m2 module:enable"
alias m2disable="m2 module:disable"
alias m2index="m2 indexer:status"
alias m2indexr="m2 indexer:reindex"
alias m2log="tail -f var/log/system.log"
alias m2elog="tail -f var/log/exception.log"
alias m2debug="tail -f var/log/debug.log"

# Function for enabling/disabling modules
function mg-module() {
  if [[ $1 == "enable" && -n $2 ]]; then
    m2 module:enable $2
  elif [[ $1 == "disable" && -n $2 ]]; then
    m2 module:disable $2
  else
    m2 module:status
  fi
}

# Create administrator
function mg-admin-create() {
  local username=${1:-"admin"}
  local email=${2:-"admin@example.com"}
  local firstname=${3:-"Admin"}
  local lastname=${4:-"User"}
  local password=${5:-"admin123"}
  
  m2 admin:user:create --admin-user=$username --admin-password=$password --admin-email=$email --admin-firstname=$firstname --admin-lastname=$lastname
  echo "Administrator created: $username ($email)"
}

# Change administrator password
function mg-admin-password() {
  local username=${1:-"admin"}
  local password=${2:-"admin123"}
  
  m2 admin:user:unlock $username
  m2 admin:user:create --admin-user=$username --admin-password=$password --admin-email="" --admin-firstname="" --admin-lastname="" --magento-init-params="--no-interaction"
  echo "Password for $username changed to $password"
}

# Work with database
function mg-db-info() {
  local root=$(_get_magento_root)
  if [[ -f "$root/app/etc/env.php" ]]; then
    php -r '
      $env = include "'$root'/app/etc/env.php";
      if (isset($env["db"]["connection"]["default"])) {
        $db = $env["db"]["connection"]["default"];
        echo "DB Host: " . $db["host"] . "\n";
        echo "DB Name: " . $db["dbname"] . "\n";
        echo "DB User: " . $db["username"] . "\n";
      } else {
        echo "Database configuration not found\n";
      }
    '
  else
    echo "Magento configuration file not found"
  fi
}

# Deploy multilanguage static files
function mg-deploy-langs() {
  local langs=${1:-"en_US"}
  m2 setup:static-content:deploy -f $langs
}

# Quick system update (all in one command)
function mg-update() {
  local root=$(_get_magento_root)
  cd $root
  
  echo "=== Starting Magento update ==="
  echo "1. Clearing cache..."
  m2 cache:flush
  echo "2. Updating database..."
  m2 setup:upgrade
  echo "3. Compiling DI..."
  m2 setup:di:compile
  echo "4. Deploying static files..."
  m2 setup:static-content:deploy -f
  echo "5. Reindexing..."
  m2 indexer:reindex
  echo "=== Update completed ==="
}

# Function to check system status
function mg-status() {
  local root=$(_get_magento_root)
  cd $root
  
  echo "=== Magento 2 Status ==="
  echo "Working mode:"
  m2 deploy:mode:show
  echo "\nMaintenance status:"
  m2 maintenance:status
  echo "\nIndex status:"
  m2 indexer:status
  echo "\nCache status:"
  m2 cache:status
  echo "===================="
}

# Function for quick cleanup of temporary files
function mg-clean() {
  local root=$(_get_magento_root)
  cd $root
  
  echo "Cleaning temporary files and cache..."
  rm -rf var/cache/* var/page_cache/* var/view_preprocessed/* pub/static/frontend/* pub/static/adminhtml/* var/di/* generated/code/*
  m2 cache:flush
  echo "Cleanup completed."
}

# Command completion for Magento CLI commands
compdef '_arguments "1: :((cache\:"Cache operations" setup\:"Setup operations" module\:"Module operations" deploy\:"Deploy operations" indexer\:"Indexer operations" admin\:"Admin operations" dev\:"Dev operations" maintenance\:"Maintenance operations" config\:"Config operations"))"' m2
