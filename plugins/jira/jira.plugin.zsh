# To use: add a .jira-url file in the base of your project
#         You can also set JIRA_URL in your .zshrc or put .jira-url in your home directory
#         .jira-url in the current directory takes precedence
#
# If you use Rapid Board, set:
#JIRA_RAPID_BOARD="true"
# in you .zshrc
#
# Setup: cd to/my/project
#        echo "https://name.jira.com" >> .jira-url
# Usage: jira           # opens a new issue
#        jira ABC-123   # Opens an existing issue
open_jira_issue () {
  local open_cmd
  if [[ $(uname -s) == 'Darwin' ]]; then
    open_cmd='open'
  else
    open_cmd='xdg-open'
  fi

  if [ -f .jira-url ]; then
    jira_url=$(cat .jira-url)
  elif [ -f ~/.jira-url ]; then
    jira_url=$(cat ~/.jira-url)
  elif [[ "x$JIRA_URL" != "x" ]]; then
    jira_url=$JIRA_URL
  else
    echo "JIRA url is not specified anywhere."
    return 0
  fi

  if [ -f .jira-prefix ]; then
    jira_prefix=$(cat .jira-prefix)
  elif [ -f ~/.jira-prefix ]; then
    jira_prefix=$(cat ~/.jira-prefix)
  else
    jira_prefix=""
  fi

  if [ -z "$1" ]; then
    echo "Opening new issue"
    $open_cmd "$jira_url/secure/CreateIssue!default.jspa"
  else
    echo "Opening issue #$1"
    if [[ "x$JIRA_RAPID_BOARD" = "xtrue" ]]; then
      $open_cmd  "$jira_url/issues/$jira_prefix$1"
    else
      $open_cmd  "$jira_url/browse/$jira_prefix$1"
    fi
  fi
}

alias jira='open_jira_issue'
