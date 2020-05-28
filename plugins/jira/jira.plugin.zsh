# CLI support for JIRA interaction
#
# See README.md for details

function jira() {
  emulate -L zsh
  local action jira_url jira_prefix
  if [[ -n "$1" ]]; then
    action=$1
  elif [[ -f .jira-default-action ]]; then
    action=$(cat .jira-default-action)
  elif [[ -f ~/.jira-default-action ]]; then
    action=$(cat ~/.jira-default-action)
  elif [[ -n "${JIRA_DEFAULT_ACTION}" ]]; then
    action=${JIRA_DEFAULT_ACTION}
  else
    action="new"
  fi

  if [[ -f .jira-url ]]; then
    jira_url=$(cat .jira-url)
  elif [[ -f ~/.jira-url ]]; then
    jira_url=$(cat ~/.jira-url)
  elif [[ -n "${JIRA_URL}" ]]; then
    jira_url=${JIRA_URL}
  else
    _jira_url_help
    return 1
  fi

  if [[ -f .jira-prefix ]]; then
    jira_prefix=$(cat .jira-prefix)
  elif [[ -f ~/.jira-prefix ]]; then
    jira_prefix=$(cat ~/.jira-prefix)
  elif [[ -n "${JIRA_PREFIX}" ]]; then
    jira_prefix=${JIRA_PREFIX}
  else
    jira_prefix=""
  fi


  if [[ $action == "new" ]]; then
    echo "Opening new issue"
    open_command "${jira_url}/secure/CreateIssue!default.jspa"
  elif [[ "$action" == "assigned" || "$action" == "reported" ]]; then
    _jira_query ${@:-$action}
  elif [[ "$action" == "myissues" ]]; then
    echo "Opening my issues"
    open_command "${jira_url}/issues/?filter=-1"
  elif [[ "$action" == "dashboard" ]]; then
    echo "Opening dashboard"
    if [[ "$JIRA_RAPID_BOARD" == "true" ]]; then
      open_command "${jira_url}/secure/RapidBoard.jspa"
    else
      open_command "${jira_url}/secure/Dashboard.jspa"
    fi
  elif [[ "$action" == "tempo" ]]; then
    echo "Opening tempo"
    open_command "${jira_url}/secure/Tempo.jspa"
  elif [[ "$action" == "dumpconfig" ]]; then
    echo "JIRA_URL=$jira_url"
    echo "JIRA_PREFIX=$jira_prefix"
    echo "JIRA_NAME=$JIRA_NAME"
    echo "JIRA_RAPID_BOARD=$JIRA_RAPID_BOARD"
    echo "JIRA_DEFAULT_ACTION=$JIRA_DEFAULT_ACTION"
  else
    # Anything that doesn't match a special action is considered an issue name
    # but `branch` is a special case that will parse the current git branch
    local issue_arg issue
    if [[ "$action" == "branch" ]]; then
      # Get name of the branch
      issue_arg=$(git rev-parse --abbrev-ref HEAD)
      # Strip prefixes like feature/ or bugfix/
      issue_arg=${issue_arg##*/}
      # Strip suffixes starting with _
      issue_arg=(${(s:_:)issue_arg})
      issue_arg=${issue_arg[1]}
      if [[ "$issue_arg" = ${jira_prefix}* ]]; then
        issue="${issue_arg}"
      else
        issue="${jira_prefix}${issue_arg}"
      fi
    else
      issue_arg=${(U)action}
      issue="${jira_prefix}${issue_arg}"
    fi

    local url_fragment
    if [[ "$2" == "m" ]]; then
      url_fragment="#add-comment"
      echo "Add comment to issue #$issue"
    else
      echo "Opening issue #$issue"
    fi
    open_command "${jira_url}/browse/${issue}${url_fragment}"
  fi
}

function _jira_url_help() {
  cat << EOF
error: JIRA URL is not specified anywhere.

Valid options, in order of precedence:
  .jira-url file
  \$HOME/.jira-url file
  \$JIRA_URL environment variable
EOF
}

function _jira_query() {
  emulate -L zsh
  local verb="$1"
  local jira_name lookup preposition query
  if [[ "${verb}" == "reported" ]]; then
    lookup=reporter
    preposition=by
  elif [[ "${verb}" == "assigned" ]]; then
    lookup=assignee
    preposition=to
  else
    echo "error: not a valid lookup: $verb" >&2
    return 1
  fi
  jira_name=${2:=$JIRA_NAME}
  if [[ -z $jira_name ]]; then
    echo "error: JIRA_NAME not specified" >&2
    return 1
  fi

  echo "Browsing issues ${verb} ${preposition} ${jira_name}"
  query="${lookup}+%3D+%22${jira_name}%22+AND+resolution+%3D+unresolved+ORDER+BY+priority+DESC%2C+created+ASC"
  open_command "${jira_url}/secure/IssueNavigator.jspa?reset=true&jqlQuery=${query}"
}
