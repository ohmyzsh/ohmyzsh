# Gets the current branch.
function git-branch() {
  local ref="$(git symbolic-ref HEAD 2> /dev/null)"
  if [[ -n "$ref" ]]; then
    echo "${ref#refs/heads/}"
    return 0
  else
    return 1
  fi
}

# Gets the repository root.
function git-root() {
  local root="$(git rev-parse --show-toplevel 2> /dev/null)"
  if [[ -n "$root" ]]; then
    echo "$root"
    return 0
  else
    return 1
  fi
}

# Open the GitHub repository in the browser.
function git-hub() {
  local url=$(
    git config -l \
      | grep "remote.origin.url" \
      | sed -En "s/remote.origin.url=(git|https?)(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\4\/\5/p"
  )

  if [[ -n "$url" ]]; then
    url="${url}/tree/${$(git-branch):-master}"

    if (( $+commands[$BROWSER] )); then
      "$BROWSER" "$url"
      return 0
    else
      echo "fatal: Browser not set or set to a non-existent browser." >&2
      return 1
    fi
  else
    echo "fatal: Not a Git repository or origin remote not set." >&2
    return 1
  fi
}

