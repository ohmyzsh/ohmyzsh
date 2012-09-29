# To use: add a .jira-url file containing your 
# Jira project's base url in the root of your project.
# Example: https://name.jira.com
# Usage: jira           # opens a new issue
#        jira ABC-123   # Opens an existing issue
open_jira_issue () {
  if [ ! -f .jira-url ]; then
    echo "There is no .jira-url file in the current directory or your home folder..."
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
