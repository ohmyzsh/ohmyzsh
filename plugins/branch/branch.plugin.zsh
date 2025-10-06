# Branch: displays the current Git or Mercurial branch fast.
# Victor Torres <vpaivatorres@gmail.com>
# Oct 2, 2015

function branch_prompt_info() {
  # Start checking in current working directory
  local branch="" dir="$PWD"
  while [[ "$dir" != '/' ]]; do
    # Found .git directory
    if [[ -d "${dir}/.git" ]]; then
      branch="${"$(<"${dir}/.git/HEAD")"##ref: refs/heads/}"
      echo '±' "${branch:gs/%/%%}"
      return
    fi

    # Found .hg directory
    if [[ -d "${dir}/.hg" ]]; then
      if [[ -f "${dir}/.hg/branch" ]]; then
        branch="$(<"${dir}/.hg/branch")"
      else
        branch="default"
      fi

      if [[ -f "${dir}/.hg/bookmarks.current" ]]; then
        branch="${branch}/$(<"${dir}/.hg/bookmarks.current")"
      fi

      echo '☿' "${branch:gs/%/%%}"
      return
    fi

    # Check parent directory
    dir="${dir:h}"
  done
}
