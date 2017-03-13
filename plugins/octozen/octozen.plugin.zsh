# octozen plugin

# Displays a zen from octocat 
#
function display_octozen() {
  local command="curl -s https://api.github.com/octocat"	
  local zen=$(eval ${command})
  if [ "$zen" != "" ]; then
    printf '%s\n' ${zen}
  fi
}

display_octozen
