# Activates autoenv or reports its failure
if ! source $HOME/.autoenv/activate.sh 2>/dev/null; then
  echo '-------- AUTOENV ---------'
  echo 'Could not find ~/.autoenv/activate.sh.'
  echo 'Please check if autoenv is correctly installed.'
  echo 'In the meantime the autoenv plugin is DISABLED.'
  echo '--------------------------'
  return 1
fi
