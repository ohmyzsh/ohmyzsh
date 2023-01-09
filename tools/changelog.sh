#!/usr/bin/env zsh

cd "$ZSH"
setopt extendedglob

##############################
# CHANGELOG SCRIPT CONSTANTS #
##############################

#* Holds the list of valid types recognized in a commit subject
#* and the display string of such type
local -A TYPES
TYPES=(
  build     "Build system"
  chore     "Chore"
  ci        "CI"
  docs      "Documentation"
  feat      "Features"
  fix       "Bug fixes"
  perf      "Performance"
  refactor  "Refactor"
  style     "Style"
  test      "Testing"
)

#* Types that will be displayed in their own section, in the order specified here.
local -a MAIN_TYPES
MAIN_TYPES=(feat fix perf docs)

#* Types that will be displayed under the category of other changes
local -a OTHER_TYPES
OTHER_TYPES=(refactor style other)

#* Commit types that don't appear in $MAIN_TYPES nor $OTHER_TYPES
#* will not be displayed and will simply be ignored.
local -a IGNORED_TYPES
IGNORED_TYPES=(${${${(@k)TYPES}:|MAIN_TYPES}:|OTHER_TYPES})

############################
# COMMIT PARSING UTILITIES #
############################

function parse-commit {

  # This function uses the following globals as output: commits (A),
  # subjects (A), scopes (A) and breaking (A). All associative arrays (A)
  # have $hash as the key.
  # - commits holds the commit type
  # - subjects holds the commit subject
  # - scopes holds the scope of a commit
  # - breaking holds the breaking change warning if a commit does
  #   make a breaking change

  function commit:type {
    local type

    # Parse commit type from the subject
    if [[ "$1" =~ '^([a-zA-Z_\-]+)(\(.+\))?!?: .+$' ]]; then
      type="${match[1]}"
    fi

    # If $type doesn't appear in $TYPES array mark it as 'other'
    if [[ -n "$type" && -n "${(k)TYPES[(i)$type]}" ]]; then
      echo $type
    else
      echo other
    fi
  }

  function commit:scope {
    local scope

    # Try to find scope in "type(<scope>):" format
    if [[ "$1" =~ '^[a-zA-Z_\-]+\((.+)\)!?: .+$' ]]; then
      echo "${match[1]}"
      return
    fi

    # If no scope found, try to find it in "<scope>:" format
    if [[ "$1" =~ '^([a-zA-Z_\-]+): .+$' ]]; then
      scope="${match[1]}"
      # Make sure it's not a type before printing it
      if [[ -z "${(k)TYPES[(i)$scope]}" ]]; then
        echo "$scope"
      fi
    fi
  }

  function commit:subject {
    # Only display the relevant part of the commit, i.e. if it has the format
    # type[(scope)!]: subject, where the part between [] is optional, only
    # displays subject. If it doesn't match the format, returns the whole string.
    if [[ "$1" =~ '^[a-zA-Z_\-]+(\(.+\))?!?: (.+)$' ]]; then
      echo "${match[2]}"
    else
      echo "$1"
    fi
  }

  # Return subject if the body or subject match the breaking change format
  function commit:is-breaking {
    local subject="$1" body="$2" message

    if [[ "$body" =~ "BREAKING CHANGE: (.*)" || \
      "$subject" =~ '^[^ :\)]+\)?!: (.*)$' ]]; then
      message="${match[1]}"
      # remove CR characters (might be inserted in GitHub UI commit description form)
      message="${message//$'\r'/}"
      # skip next paragraphs (separated by two newlines or more)
      message="${message%%$'\n\n'*}"
      # ... and replace newlines with spaces
      echo "${message//$'\n'/ }"
    else
      return 1
    fi
  }

  # Return truncated hash of the reverted commit
  function commit:is-revert {
    local subject="$1" body="$2"

    if [[ "$subject" = Revert* && \
      "$body" =~ "This reverts commit ([^.]+)\." ]]; then
      echo "${match[1]:0:7}"
    else
      return 1
    fi
  }

  # Parse commit with hash $1
  local hash="$1" subject="$2" body="$3" warning rhash

  # Commits following Conventional Commits (https://www.conventionalcommits.org/)
  # have the following format, where parts between [] are optional:
  #
  #  type[(scope)][!]: subject
  #
  #  commit body
  #  [BREAKING CHANGE: warning]

  # commits holds the commit type
  types[$hash]="$(commit:type "$subject")"
  # scopes holds the commit scope
  scopes[$hash]="$(commit:scope "$subject")"
  # subjects holds the commit subject
  subjects[$hash]="$(commit:subject "$subject")"

  # breaking holds whether a commit has breaking changes
  # and its warning message if it does
  if warning=$(commit:is-breaking "$subject" "$body"); then
    breaking[$hash]="$warning"
  fi

  # reverts holds commits reverted in the same release
  if rhash=$(commit:is-revert "$subject" "$body"); then
    reverts[$hash]=$rhash
  fi
}

#############################
# RELEASE CHANGELOG DISPLAY #
#############################

function display-release {

  # This function uses the following globals: output, version,
  # types (A), subjects (A), scopes (A), breaking (A) and reverts (A).
  #
  # - output is the output format to use when formatting (raw|text|md)
  # - version is the version in which the commits are made
  # - types, subjects, scopes, breaking, and reverts are associative arrays
  #   with commit hashes as keys

  # Remove commits that were reverted
  local hash rhash
  for hash rhash in ${(kv)reverts}; do
    if (( ${+types[$rhash]} )); then
      # Remove revert commit
      unset "types[$hash]" "subjects[$hash]" "scopes[$hash]" "breaking[$hash]"
      # Remove reverted commit
      unset "types[$rhash]" "subjects[$rhash]" "scopes[$rhash]" "breaking[$rhash]"
    fi
  done

  # Remove commits from ignored types unless it has breaking change information
  for hash in ${(k)types[(R)${(j:|:)IGNORED_TYPES}]}; do
    (( ! ${+breaking[$hash]} )) || continue
    unset "types[$hash]" "subjects[$hash]" "scopes[$hash]"
  done

  # If no commits left skip displaying the release
  if (( $#types == 0 )); then
    return
  fi

  # Get length of longest scope for padding
  local max_scope=0
  for hash in ${(k)scopes}; do
    max_scope=$(( max_scope < ${#scopes[$hash]} ? ${#scopes[$hash]} : max_scope ))
  done

  ##* Formatting functions

  # Format the hash according to output format
  # If no parameter is passed, assume it comes from `$hash`
  function fmt:hash {
    #* Uses $hash from outer scope
    local hash="${1:-$hash}"
    case "$output" in
    raw) printf '%s' "$hash" ;;
    text) printf '\e[33m%s\e[0m' "$hash" ;; # red
    md) printf '[`%s`](https://github.com/ohmyzsh/ohmyzsh/commit/%s)' "$hash" "$hash" ;;
    esac
  }

  # Format headers according to output format
  # Levels 1 to 2 are considered special, the rest are formatted
  # the same, except in md output format.
  function fmt:header {
    local header="$1" level="$2"
    case "$output" in
    raw)
      case "$level" in
      1) printf '%s\n%s\n\n' "$header" "$(printf '%.0s=' {1..${#header}})" ;;
      2) printf '%s\n%s\n\n' "$header" "$(printf '%.0s-' {1..${#header}})" ;;
      *) printf '%s:\n\n' "$header" ;;
      esac ;;
    text)
      case "$level" in
      1|2) printf '\e[1;4m%s\e[0m\n\n' "$header" ;; # bold, underlined
      *) printf '\e[1m%s:\e[0m\n\n' "$header" ;; # bold
      esac ;;
    md) printf '%s %s\n\n' "$(printf '%.0s#' {1..${level}})" "$header" ;;
    esac
  }

  function fmt:scope {
    #* Uses $scopes (A) and $hash from outer scope
    local scope="${1:-${scopes[$hash]}}"

    # If no scopes, exit the function
    if [[ $max_scope -eq 0 ]]; then
      return
    fi

    # Get how much padding is required for this scope
    local padding=0
    padding=$(( max_scope < ${#scope} ? 0 : max_scope - ${#scope} ))
    padding="${(r:$padding:: :):-}"

    # If no scope, print padding and 3 spaces (equivalent to "[] ")
    if [[ -z "$scope" ]]; then
      printf "${padding}   "
      return
    fi

    # Print [scope]
    case "$output" in
    raw|md) printf '[%s]%s ' "$scope" "$padding";;
    text) printf '[\e[38;5;9m%s\e[0m]%s ' "$scope" "$padding";; # red 9
    esac
  }

  # If no parameter is passed, assume it comes from `$subjects[$hash]`
  function fmt:subject {
    #* Uses $subjects (A) and $hash from outer scope
    local subject="${1:-${subjects[$hash]}}"

    # Capitalize first letter of the subject
    subject="${(U)subject:0:1}${subject:1}"

    case "$output" in
    raw) printf '%s' "$subject" ;;
    # In text mode, highlight (#<issue>) and dim text between `backticks`
    text) sed -E $'s|#([0-9]+)|\e[32m#\\1\e[0m|g;s|`([^`]+)`|`\e[2m\\1\e[0m`|g' <<< "$subject" ;;
    # In markdown mode, link to (#<issue>) issues
    md) sed -E 's|#([0-9]+)|[#\1](https://github.com/ohmyzsh/ohmyzsh/issues/\1)|g' <<< "$subject" ;;
    esac
  }

  function fmt:type {
    #* Uses $type from outer scope
    local type="${1:-${TYPES[$type]:-${(C)type}}}"
    [[ -z "$type" ]] && return 0
    case "$output" in
    raw|md) printf '%s: ' "$type" ;;
    text) printf '\e[4m%s\e[24m: ' "$type" ;; # underlined
    esac
  }

  ##* Section functions

  function display:version {
    fmt:header "$version" 2
  }

  function display:breaking {
    (( $#breaking != 0 )) || return 0

    case "$output" in
    text) printf '\e[31m'; fmt:header "BREAKING CHANGES" 3 ;;
    raw) fmt:header "BREAKING CHANGES" 3 ;;
    md) fmt:header "BREAKING CHANGES ⚠" 3 ;;
    esac

    local hash message
    local wrap_width=$(( (COLUMNS < 100 ? COLUMNS : 100) - 3 ))
    for hash message in ${(kv)breaking}; do
      # Format the BREAKING CHANGE message by word-wrapping it at maximum 100
      # characters (use $COLUMNS if smaller than 100)
      message="$(fmt -w $wrap_width <<< "$message")"
      # Display hash and scope in their own line, and then the full message with
      # blank lines as separators and a 3-space left padding
      echo " - $(fmt:hash) $(fmt:scope)\n\n$(fmt:subject "$message" | sed 's/^/   /')\n"
    done
  }

  function display:type {
    local hash type="$1"

    local -a hashes
    hashes=(${(k)types[(R)$type]})

    # If no commits found of type $type, go to next type
    (( $#hashes != 0 )) || return 0

    fmt:header "${TYPES[$type]}" 3
    for hash in $hashes; do
      echo " - $(fmt:hash) $(fmt:scope)$(fmt:subject)"
    done | sort -k3 # sort by scope
    echo
  }

  function display:others {
    local hash type

    # Commits made under types considered other changes
    local -A changes
    changes=(${(kv)types[(R)${(j:|:)OTHER_TYPES}]})

    # If no commits found under "other" types, don't display anything
    (( $#changes != 0 )) || return 0

    fmt:header "Other changes" 3
    for hash type in ${(kv)changes}; do
      case "$type" in
      other) echo " - $(fmt:hash) $(fmt:scope)$(fmt:subject)" ;;
      *) echo " - $(fmt:hash) $(fmt:scope)$(fmt:type)$(fmt:subject)" ;;
      esac
    done | sort -k3 # sort by scope
    echo
  }

  ##* Release sections order

  # Display version header
  display:version

  # Display breaking changes first
  display:breaking

  # Display changes for commit types in the order specified
  for type in $MAIN_TYPES; do
    display:type "$type"
  done

  # Display other changes
  display:others
}

function main {
  # $1 = until commit, $2 = since commit
  local until="$1" since="$2"

  # $3 = output format (--text|--raw|--md)
  # --md:   uses markdown formatting
  # --raw:  outputs without style
  # --text: uses ANSI escape codes to style the output
  local output=${${3:-"--text"}#--*}

  if [[ -z "$until" ]]; then
    until=HEAD
  fi

  if [[ -z "$since" ]]; then
    # If $since is not specified:
    # 1) try to find the version used before updating
    # 2) try to find the first version tag before $until
    since=$(command git config --get oh-my-zsh.lastVersion 2>/dev/null) || \
    since=$(command git describe --abbrev=0 --tags "$until^" 2>/dev/null) || \
    unset since
  elif [[ "$since" = --all ]]; then
    unset since
  fi

  # Commit classification arrays
  local -A types subjects scopes breaking reverts
  local truncate=0 read_commits=0
  local version tag
  local hash refs subject body

  # Get the first version name:
  # 1) try tag-like version, or
  # 2) try branch name, or
  # 3) try name-rev, or
  # 4) try short hash
  version=$(command git describe --tags $until 2>/dev/null) \
    || version=$(command git symbolic-ref --quiet --short $until 2>/dev/null) \
    || version=$(command git name-rev --no-undefined --name-only --exclude="remotes/*" $until 2>/dev/null) \
    || version=$(command git rev-parse --short $until 2>/dev/null)

  # Get commit list from $until commit until $since commit, or until root commit if $since is unset
  local range=${since:+$since..}$until

  # Git log options
  # -z:             commits are delimited by null bytes
  # --format:       [7-char hash]<field sep>[ref names]<field sep>[subject]<field sep>[body]
  # --abbrev=7:     force commit hashes to be 7 characters long
  # --no-merges:    merge commits are omitted
  # --first-parent: commits from merged branches are omitted
  local SEP="0mZmAgIcSeP"
  local -a raw_commits
  raw_commits=(${(0)"$(command git -c log.showSignature=false log -z \
    --format="%h${SEP}%D${SEP}%s${SEP}%b" --abbrev=7 \
    --no-merges --first-parent $range)"})

  local raw_commit
  local -a raw_fields
  for raw_commit in $raw_commits; do
    # Truncate list on versions with a lot of commits
    if [[ -z "$since" ]] && (( ++read_commits > 35 )); then
      truncate=1
      break
    fi

    # Read the commit fields (@ is needed to keep empty values)
    eval "raw_fields=(\"\${(@ps:$SEP:)raw_commit}\")"
    hash="${raw_fields[1]}"
    refs="${raw_fields[2]}"
    subject="${raw_fields[3]}"
    body="${raw_fields[4]}"

    # If we find a new release (exact tag)
    if [[ "$refs" = *tag:\ * ]]; then
      # Parse tag name (needs: setopt extendedglob)
      tag="${${refs##*tag: }%%,# *}"
      # Output previous release
      display-release
      # Reinitialize commit storage
      types=()
      subjects=()
      scopes=()
      breaking=()
      reverts=()
      # Start work on next release
      version="$tag"
      read_commits=1
    fi

    parse-commit "$hash" "$subject" "$body"
  done

  display-release

  if (( truncate )); then
    echo " ...more commits omitted"
    echo
  fi
}

# Use raw output if stdout is not a tty
if [[ ! -t 1 && -z "$3" ]]; then
  main "$1" "$2" --raw
else
  main "$@"
fi
