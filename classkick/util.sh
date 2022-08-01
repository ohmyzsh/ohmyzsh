function git-diff-subdirs() {
  for DIR in */; do
    pushd $DIR
    echo "Git diffing $PWD"
    git --no-pager diff -- ':!*poetry.lock'
    popd
  done
}
