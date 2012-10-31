# To use: add a .jira-url file in the base of your project
# Setup: cd to/my/project
#        echo "https://name.jira.com" >> .jira-url
# Usage: jira           # opens a new issue
#        jira ABC-123   # Opens an existing issue
open_jira_issue () {
  if [ ! -f .jira-url ]; then
    echo "There is no .jira-url file in the current directory..."
    return 0;
  else
    jira_url=$(cat .jira-url);
    if [ -z "$1" ]; then
      echo "Opening new issue";
      `open $jira_url/secure/CreateIssue!default.jspa`;
    else
      echo "Opening issue #$1";
      `open $jira_url/issues/$1`;
    fi
  fi
}

alias jira='open_jira_issue'
