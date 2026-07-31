# Bump the repo's latest MAJOR.MINOR.PATCH tag and create a new one.
# If no tag exists yet, bootstraps: gtM -> 1.0.0, gtm -> 0.1.0, gtp -> 0.0.1
# Usage:
#   gtM|gtm|gtp    lightweight tag
#   gtvM|gtvm|gtvp (bootstrap only) prefix the first tag with "v"
# Case-sensitive: M = major, m = minor, p = patch.
# Anything else you pass is forwarded straight to `git tag` after the computed
# name, e.g. `gtM --annotate -m "message"` or `gtM -s -m "message"` (signed).
_semver_tag_bump() {
  local part="$1"; shift
  local v_prefix_requested=false
  while [[ "$1" == "-v" || "$1" == "--v-prefix" ]]; do
    v_prefix_requested=true
    shift
  done

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not inside a git repository." >&2
    return 1
  fi

  local latest
  latest=$(git for-each-ref --sort=-creatordate --format='%(refname:short)' refs/tags --count=1)

  local prefix major minor patch
  local requested_prefix=""
  $v_prefix_requested && requested_prefix="v"
  local mismatch=false

  if [[ -z "$latest" ]]; then
    prefix="$requested_prefix"
    case "$part" in
      major) major=1; minor=0; patch=0 ;;
      minor) major=0; minor=1; patch=0 ;;
      patch) major=0; minor=0; patch=1 ;;
    esac
  else
    if [[ ! "$latest" =~ ^v?[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "Latest tag '$latest' isn't MAJOR.MINOR.PATCH (optional v prefix) - refusing to guess the next version." >&2
      return 1
    fi
    prefix=""
    [[ "$latest" == v* ]] && prefix="v"
    [[ "$prefix" != "$requested_prefix" ]] && mismatch=true
    local ver="${latest#v}"
    IFS='.' read -r major minor patch <<< "$ver"
    case "$part" in
      major) major=$((major + 1)); minor=0; patch=0 ;;
      minor) minor=$((minor + 1)); patch=0 ;;
      patch) patch=$((patch + 1)) ;;
    esac
  fi

  local newtag="${prefix}${major}.${minor}.${patch}"

  if $mismatch; then
    print -n "Running this will create $newtag, but your existing tags are formatted $latest, are you sure? [y/N] "
  else
    print -n "This will create tag $newtag, continue? [y/N] "
  fi
  read REPLY
  if [[ "$REPLY" != [Yy]* ]]; then
    echo "Aborted."
    return 1
  fi

  git tag "$newtag" "$@" || return 1

  if [[ -n "$latest" ]]; then
    echo "Created tag $newtag (previous latest: $latest)"
  else
    echo "Created tag $newtag (first tag in repo)"
  fi
}

gtM() { _semver_tag_bump major "$@" }
gtm() { _semver_tag_bump minor "$@" }
gtp() { _semver_tag_bump patch "$@" }

alias gtvM='gtM -v'
alias gtvm='gtm -v'
alias gtvp='gtp -v'
