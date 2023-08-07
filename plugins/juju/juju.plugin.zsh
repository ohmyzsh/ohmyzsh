# ---------------------------------------------------------- #
# Aliases and functions for juju (https://juju.is)           #
# ---------------------------------------------------------- #

# Load TAB completions
# You need juju's bash completion script installed. By default bash-completion's
# location will be used (i.e. pkg-config --variable=completionsdir bash-completion).
completion_file="$(pkg-config --variable=completionsdir bash-completion 2>/dev/null)/juju" || \
  completion_file="/usr/share/bash-completion/completions/juju"
[[ -f "$completion_file" ]] && source "$completion_file"
unset completion_file

# ---------------------------------------------------------- #
# Aliases (in alphabetic order)                              #
#                                                            #
# Generally,                                                 #
#   - `!` means --force --no-wait -y                         #
#   - `ds` suffix means --destroy-storage                    #
#   - `jsh` prefix means juju show-*                         #
# ---------------------------------------------------------- #
alias j="juju"
alias jam="juju add-model --config logging-config=\"<root>=WARNING; unit=DEBUG\"\
 --config update-status-hook-interval=\"60m\""
alias jb='juju bootstrap'
alias jbng='juju bootstrap --no-gui'
alias jbl='juju bootstrap localhost'
alias jblng='juju bootstrap --no-gui localhost'
alias jbm='juju bootstrap microk8s'
alias jbmng='juju bootstrap --no-gui microk8s'
alias jc='juju config'
alias jcld='juju clouds'
alias jclda='juju clouds --all'
alias jctl='juju controllers'
alias jctlr='juju controllers --refresh'
alias jdc='juju destroy-controller --destroy-all-models'
alias 'jdc!'='juju destroy-controller --destroy-all-models --force --no-wait -y'
alias jdcds='juju destroy-controller --destroy-all-models --destroy-storage'
alias 'jdcds!'='juju destroy-controller --destroy-all-models --destroy-storage --force --no-wait -y'
alias jdm='juju destroy-model'
alias 'jdm!'='juju destroy-model --force --no-wait -y'
alias jdmds='juju destroy-model --destroy-storage'
alias 'jdmds!'='juju destroy-model --destroy-storage --force --no-wait -y'
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
alias 'jrm!'='juju remove-application --force --no-wait'
alias jrmds='juju remove-application --destroy-storage'
alias 'jrmds!'='juju remove-application --destroy-storage --force --no-wait'
alias jrmrel='juju remove-relation'
alias 'jrmrel!'='juju remove-relation --force'
alias jrmsas='juju remove-saas'
alias jrp='juju refresh --path'
alias jrs='juju remove-storage'
alias 'jrs!'='juju remove-storage --force'
alias jsa='juju scale-application'
alias jsha='juju show-application'
alias jshc='juju show-controller'
alias jshm='juju show-model'
alias jshsl='juju show-status-log'
alias jshu='juju show-unit'
alias jssh='juju ssh'
alias jsshc='juju ssh --container'
alias jstj='juju status --format=json'
alias jst='juju status --relations --color'
alias jsts='juju status --relations --storage --color'
alias jsw='juju switch'

# ---------------------------------------------------------- #
# Functions (in alphabetic order)                            #
# ---------------------------------------------------------- #

# Get app or unit address
jaddr() {
  # $1 = app name
  # $2 = unit number (optional)
  if (( ! ${+commands[jq]} )); then
    echo "jq is required but could not be found." >&2
    return 1
  fi

  if [[ $# -eq 1 ]]; then
    # Get app address
    juju status "$1" --format=json \
      | jq -r ".applications.\"$1\".address"
  elif [[ $# -eq 2 ]]; then
    # Get unit address
    juju status "$1/$2" --format=json \
      | jq -r ".applications.\"$1\".units.\"$1/$2\".address"
  else
    echo "Invalid number of arguments."
    echo "Usage:   jaddr <app-name> [<unit-number>]"
    echo "Example: jaddr karma"
    echo "Example: jaddr karma 0"
    return 1
  fi
}

# Destroy all controllers
jclean() {
  if (( ! ${+commands[jq]} )); then
    echo "jq is required but could not be found." >&2
    return 1
  fi

  local controllers=$(juju controllers --format=json | jq -r '.controllers | keys[]' 2>/dev/null)
  if [[ -z "$controllers" ]]; then
    echo "No controllers registered"
    return 0
  fi

  echo "This will forcefully destroy all storages, models and controllers."
  echo "Controllers to be destroyed:"
  echo "$controllers"

  if ! read -q '?Are you sure (y/n)? '; then
    echo
    echo "Aborted."
    return 0
  fi

  echo
  for controller in ${=controllers}; do
    timeout 2m juju destroy-controller --destroy-all-models --destroy-storage --force --no-wait -y $controller
    timeout 2m juju kill-controller -y -t 0 $controller 2>/dev/null
    timeout 10s juju unregister $controller 2>/dev/null
  done
}

# Display app and unit relation data
jreld() {
  # $1 = relation name
  # $2 = app name
  # $3 = unit number
  if [[ $# -ne 3 ]]; then
    echo "Invalid number of arguments."
    echo "Usage:   jreld <relation-name> <app-name> <unit-number>"
    echo "Example: jreld karma-dashboard alertmanager 0"
    return 1
  fi

  local relid="$(juju run "relation-ids $1" --unit $2/$3)"
  if [[ -z "$relid" ]]; then
    return 1
  fi

  echo "App data:"
  juju run "relation-get -r $relid --app - $2" --unit $2/$3
  echo
  echo "Unit data:"
  juju run "relation-get -r $relid - $2" --unit $2/$3
}

# Return Juju current controller
jcontroller() {
  local controller="$(awk '/current-controller/ {print $2}' ~/.local/share/juju/controllers.yaml)"
  if [[ -z "$controller" ]]; then
    return 1
  fi

  echo $controller
  return 0
}

# Return Juju current model
jmodel() {
  local yqbin="$(whereis yq | awk '{print $2}')"

  if [[ -z "$yqbin" ]]; then
    echo "--"
    return 1
  fi

  local model="$(yq e ".controllers.$(jcontroller).current-model" < ~/.local/share/juju/models.yaml | cut -d/ -f2)"
  
  if [[ -z "$model" ]]; then
    echo "--"
    return 1
  fi

  echo $model
  return 0
}

# Watch juju status, with optional interval (default: 5 sec)
wjst() {
  local interval="${1:-5}"
  shift $(( $# > 0 ))
  watch -n "$interval" --color juju status --relations --color "$@"
}
