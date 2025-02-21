# CLI support for JIRA interaction
#
# See README.md for details

function _jira_usage() {
cat <<EOF
jira                            Performs the default action
jira new                        Opens a new Jira issue dialogue
jira ABC-123                    Opens an existing issue
jira ABC-123 m                  Opens an existing issue for adding a comment
jira dashboard [rapid_view]     Opens your JIRA dashboard
jira mine                       Queries for your own issues
jira tempo                      Opens your JIRA Tempo
jira reported [username]        Queries for issues reported by a user
jira assigned [username]        Queries for issues assigned to a user
jira branch                     Opens an existing issue matching the current branch name
EOF
}

# If your branch naming convention deviates, you can partially override this plugin function
# to determine the jira issue key based on your formatting.
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#partially-overriding-an-existing-plugin
function jira_branch() {
  # Get name of the branch
  issue_arg=$(git rev-parse --abbrev-ref HEAD)
  # Strip prefixes like feature/ or bugfix/
  issue_arg=${issue_arg##*/}
  # Strip suffixes starting with _
  issue_arg=(${(s:_:)issue_arg})
  # If there is only one part, it means that there is a different delimiter. Try with -
  if [[ ${#issue_arg[@]} = 1 && ${issue_arg} == *-* ]]; then
    issue_arg=(${(s:-:)issue_arg})
    issue_arg="${issue_arg[1]}-${issue_arg[2]}"
  else
    issue_arg=${issue_arg[1]}
  fi
  if [[ "${issue_arg:l}" = ${jira_prefix:l}* ]]; then
    echo "${issue_arg}"
  else
    echo "${jira_prefix}${issue_arg}"
  fi
}

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
  elif [[ "$action" == "help" || "$action" == "usage" ]]; then
    _jira_usage
  elif [[ "$action" == "mine" ]]; then
    echo "Opening my issues"
    open_command "${jira_url}/issues/?filter=-1"
  elif [[ "$action" == "dashboard" ]]; then
    echo "Opening dashboard"
    if [[ "$JIRA_RAPID_BOARD" == "true" ]]; then
      _jira_rapid_board ${@}
    else
      open_command "${jira_url}/secure/Dashboard.jspa"
    fi
  elif [[ "$action" == "tempo" ]]; then
    echo "Opening tempo"
    if [[ -n "$JIRA_TEMPO_PATH" ]]; then
      open_command "${jira_url}${JIRA_TEMPO_PATH}"
    else
      open_command "${jira_url}/secure/Tempo.jspa"
    fi
  elif [[ "$action" == "dumpconfig" ]]; then
    echo "JIRA_URL=$jira_url"
    echo "JIRA_PREFIX=$jira_prefix"
    echo "JIRA_NAME=$JIRA_NAME"
    echo "JIRA_RAPID_VIEW=$JIRA_RAPID_VIEW"
    echo "JIRA_RAPID_BOARD=$JIRA_RAPID_BOARD"
    echo "JIRA_DEFAULT_ACTION=$JIRA_DEFAULT_ACTION"
    echo "JIRA_TEMPO_PATH=$JIRA_TEMPO_PATH"
  else
    # Anything that doesn't match a special action is considered an issue name
    # but `branch` is a special case that will parse the current git branch
    local issue_arg issue
    if [[ "$action" == "branch" ]]; then
      issue=$(jira_branch)
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

function _jira_rapid_board() {
  rapid_view=${2:=$JIRA_RAPID_VIEW}

  if [[ -z $rapid_view ]]; then
    open_command "${jira_url}/secure/RapidBoard.jspa"
  else
    open_command "${jira_url}/secure/RapidBoard.jspa?rapidView=$rapid_view"
  fi
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
