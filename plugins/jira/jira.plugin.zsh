# CLI support for JIRA interaction
#
# Setup: 
#   Add a .jira-url file in the base of your project
#   You can also set $JIRA_URL in your .zshrc or put .jira-url in your home directory
#   A .jira-url in the current directory takes precedence. 
#   The same goes with .jira-prefix and $JIRA_PREFIX.
#
#   For example:
#     cd to/my/project
#     echo "https://name.jira.com" >> .jira-url
#
# Variables:
#  $JIRA_RAPID_BOARD     - set to "true" if you use Rapid Board
#  $JIRA_DEFAULT_ACTION  - action to do when `jira` is called witn no args
#                          defaults to "new"
#  $JIRA_NAME            - Your JIRA username. Used as default for assigned/reported
#  $JIRA_PREFIX          - Prefix added to issue ID arguments
#
#
# Usage: 
#   jira            # Performs the default action
#   jira new        # opens a new issue
#   jira reported [username]
#   jira assigned [username]
#   jira dashboard
#   jira ABC-123    # Opens an existing issue
#   jira ABC-123 m  # Opens an existing issue for adding a comment

: ${JIRA_DEFAULT_ACTION:=new}

function jira() {
  local action=${1:=$JIRA_DEFAULT_ACTION}

  local jira_url jira_prefix
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
    _jira_query $@
  elif [[ "$action" == "dashboard" ]]; then
    echo "Opening dashboard"
    open_command "${jira_url}/secure/Dashboard.jspa"
  else
    # Anything that doesn't match a special action is considered an issue name
    local issue_arg=$action
    local issue="${jira_prefix}${issue_arg}"
    local url_fragment=''
    if [[ "$2" == "m" ]]; then
      url_fragment="#add-comment"
      echo "Add comment to issue #$issue"
    else
      echo "Opening issue #$issue"
    fi
    if [[ "$JIRA_RAPID_BOARD" == "true" ]]; then
      open_command "${jira_url}/issues/${issue}${url_fragment}"
    else
      open_command "${jira_url}/browse/${issue}${url_fragment}"
    fi
  fi
}

function _jira_url_help() {
  cat << EOF
JIRA url is not specified anywhere.
Valid options, in order of precedence:
  .jira-url file
  \$HOME/.jira-url file
  JIRA_URL environment variable
EOF
}

function _jira_query() {
  local verb="$1"
  local jira_name lookup preposition query
  if [[ "${verb}" == "reported" ]]; then
    lookup=reporter
    preposition=by
  elif [[ "${verb}" == "assigned" ]]; then
    lookup=assignee
    preposition=to
  else
    echo "not a valid lookup: $verb" >&2
    return 1
  fi
  jira_name=${2:=$JIRA_NAME}
  if [[ -z $jira_name ]]; then
    echo "JIRA_NAME not specified" >&2
    return 1
  fi

  echo "Browsing issues ${verb} ${preposition} ${jira_name}"
  query="${lookup}+%3D+%22${jira_name}%22+AND+resolution+%3D+unresolved+ORDER+BY+priority+DESC%2C+created+ASC"
  open_command "${jira_url}/secure/IssueNavigator.jspa?reset=true&jqlQuery=${query}"
}

