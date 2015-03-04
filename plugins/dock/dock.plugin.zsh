function dock_usage () {
  echo
  echo  " usage: dock <command>"
  echo
  echo "JUST A TEST, THERE ARE NO COMMANDS"
}

function dock () {
  if [ -z "$1" ]; then
    dock_usage;
  # else
  #   [ "$1" = "patch" ] && gerrit_patch "$2"
  #   [ "$1" = "push" ] && gerrit_push "$branch";
  #   [ "$1" = "review" ] && gerrit_review "$branch";
  #   [ "$1" = "reset" ] && gerrit_reset;
  #   [ "$1" = "draft" ] && gerrit_draft "$branch";
  #   [ "$1" = "pull" ] && gerrit_pull "$branch";
  #   [ "$1" = "clone" ] && gerrit_clone "$2";
  #   [ "$1" = "setup" ] && gerrit_setup;
  fi
}
