# zle-line-init widget (don't redefine if already defined)
(( ! ${+functions[_jira-auto-worklog_zle-line-init]} )) || return 0

# Get the directory of this file
dir="$(dirname "$0")"

case "$widgets[zle-line-init]" in
  # Simply define the function if zle-line-init doesn't yet exist
  builtin|"") function _jira-auto-worklog_zle-line-init() {
      ($dir/jira-auto-worklog &> /dev/null)
    } ;;
  # Override the current zle-line-init widget, calling the old one
  user:*) zle -N _jira-auto-worklog_orig_zle-line-init "${widgets[zle-line-init]#user:}"
    function _jira-auto-worklog_zle-line-init() {
      ($dir/jira-auto-worklog &> /dev/null)
      zle _jira-auto-worklog_orig_zle-line-init -- "$@"
    } ;;
esac

zle -N zle-line-init _jira-auto-worklog_zle-line-init
