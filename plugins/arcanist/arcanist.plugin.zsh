arc_quick_diff () {
  git checkout -b "$(echo $1 | sed 's/[^0-9a-zA-Z]/_/g' | cut -c -20)-$(date '+%y%m%dT%H-%M-%S')"
  git commit -a -m "$1"
  all_arguments="$*"
  remaining_arguments=${all_arguments#*"$2"}
  arc diff --verbatim --allow-untracked --reviewers $2 $remaining_arguments
}


arc_quick_update () {
  git commit -a -m "$1"
  arc diff --allow-untracked -m "$1"
}


alias quickdiff='arc_quick_diff'
alias arcupdate='arc_quick_update'
