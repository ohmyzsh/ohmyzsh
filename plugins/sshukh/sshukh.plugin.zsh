# ------------------------------------------------------------------------------
# Description
# -----------
#
# User will be prompted if they want to update known_hosts if ssh errors out 
# with "Host key verification failed."
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Anatoly Kopyl <akopyl@radner.ru>
#
# ------------------------------------------------------------------------------

sshukh () {
  output=$(\ssh "$@" 2>&1)
  echo $output
  error=$(echo $output | tail -1)
  if [[ "$error" == "Host key verification failed."* ]]; then
    host=$(cut -d'@' -f2 <<< $1)
    while true; do
      read yn"?Update known_hosts? [y/n] "
      case $yn in
        [Yy]* ) ssh-keygen -R $host && \ssh "$@"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer y or n.";;
      esac
    done
  fi
}
