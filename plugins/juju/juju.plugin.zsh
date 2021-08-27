# ---------------------------------------------------------- #
# Aliases and functions for juju (https://juju.is)           #
# ---------------------------------------------------------- #

# Load TAB completions
_load_tab_completions() {
  autoload -U +X compinit && compinit
  autoload -U +X bashcompinit && bashcompinit
  local jcomp="$(pkg-config --variable=completionsdir bash-completion)/juju"
  [ -f "$jcomp" ] && source "$jcomp"
}
_load_tab_completions

# ---------------------------------------------------------- #
# Aliases (in alphabetic order)                              #
# ---------------------------------------------------------- #
alias jam='juju add-model --config logging-config="<root>=WARNING; unit=DEBUG"\
  --config update-status-hook-interval="60m"'
alias jb='juju bootstrap'
alias jbm='juju bootstrap microk8s'
alias jc='juju config'
alias jdc='juju destroy-controller --destroy-all-models'
alias jdm='juju destroy-model --destroy-storage --force --no-wait'
alias jde='juju deploy --channel=edge'
alias jd='juju deploy'
alias jdl='juju debug-log --ms'
alias jdlr='juju debug-log --ms --replay'
alias jcon='juju consume'
alias jeb='juju export-bundle'
alias jex='juju expose'
alias jh='juju help'
alias jkc='juju kill-controller -y -t 0'
alias jm='juju models'
alias jmc='juju model-config'
alias jof='juju offer'
alias jra='juju run-action'
alias jraw='juju run-action --wait'
alias jrel='juju relate'
alias jrm='juju remove-application'
alias jrmf='juju remove-application --force --no-wait'
alias jrmrel='juju remove-relation'
alias jrmsas='juju remove-saas'
alias jrp='juju refresh --path'
alias jsa='juju scale-application'
alias jsh='juju ssh'
alias jshc='juju ssh --container'
alias jshm='juju show-model'
alias jstj='juju status --format=json'
alias jst='juju status --relations --color'
alias jsw='juju switch'

# ---------------------------------------------------------- #
# Functions (in alphabetic order)                            #
# ---------------------------------------------------------- #

# Get app or unit address
jaddr() {
    # $1 = app name
    # $2 = unit number (optional)
    
    if [ "$#" -eq 1 ]; then
        # Get app address
        juju status "$1" --format=json | \
          jq -r ".applications.\"$1\".address"
        
    elif [ "$#" -eq 2 ]; then
        # Get unit address
        juju status "$1/$2" --format=json | \
          jq -r ".applications.\"$1\".units.\"$1/$2\".address"
        
    else
        echo "Invalid number of arguments."
        echo "Usage:   jaddr <app-name> [<unit-number>]"
        echo "Example: jaddr karma"
        echo "Example: jaddr karma 0"
        return 1
    fi
}

# Display app and unit relation data
jreld() {
    # $1 = relation name
    # $2 = app name
    # $3 = unit number
    if [ "$#" -ne 3 ]; then
        echo "Invalid number of arguments."
        echo "Usage:   jreld <relation-name> <app-name> <unit-number>"
        echo "Example: jreld karma-dashboard alertmanager 0"
        return 1
    fi

    local relid=$(juju run "relation-ids $1" --unit $2/$3)
    if [ -z "$relid" ]; then return 1; fi
    
    echo "App data:"
    juju run "relation-get -r $relid --app - $2" --unit $2/$3
    
    echo
    
    echo "Unit data:"
    juju run "relation-get -r $relid - $2" --unit $2/$3
}

# Watch juju status, with optional interval (default: 5 sec)
wjst() {
  local interval="${1:-5}"
  if (( $# > 0 )); then
    shift
  fi
  watch -n "$interval" --color juju status --relations --color "$@"
  return $?
}

