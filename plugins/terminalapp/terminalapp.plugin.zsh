# Set Apple Terminal.app resume directory
# based on this answer: http://superuser.com/a/315029

function chpwd {
  local SEARCH=' '
  local REPLACE='%20'
  local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
  printf '\e]7;%s\a' "$PWD_URL"
}

chpwd