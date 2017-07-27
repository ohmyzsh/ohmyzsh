# Load a go version.
# If no version is provided, 'stable' will be loaded.
load-go() {
  # check if gimme is available (unfortunately eval does not return a non-zero
  # value if the command is not found, therefore we need to check before)
  gimme &>/dev/null
  if [[ $? == 127 ]] ; then
    echo "gimme was not found in your PATH.
Run install-gimme and make sure to add ~/bin to your PATH."
    return 1
  fi
  if [[ "$#" > 1 ]] ; then
    echo "Usage: load-go GO_VERSION"
    return 0
  elif [[ "$#" == 0 ]] ; then
    eval "$(gimme stable)"
  else
    eval "$(gimme ${*})"
  fi
  return $?
}

# alias for gimme -l
alias go-versions='gimme -l'

# download latest version of gimme
install-gimme() {
  if ! [ -d ~/bin ] ; then
    mkdir ~/bin || return 1
  fi
  curl -sL -o ~/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
  chmod +x ~/bin/gimme || return 1
  return 0
}

# remove go version from ~/.gimme/*
remove-go() {
  if [[ "$#" != 1 ]] ; then
    echo "Usage: remove-go GO_VERSION"
    return 0
  else
    if [ "$1" = "tip" ] ; then
      if ! [ -e ~/.gimme/versions/go ] ; then
        echo "go version tip is not installed"
        return 0
      fi
      rm -rf ~/.gimme/versions/go || return 1
      rm ~/.gimme/envs/gotip.env || return 1
      rm ~/.gimme/envs/go.git.* || return 1
      return 0
    elif [ "$1" = "stable" ] ; then
      if ! [ -e ~/.gimme/versions/stable ] ; then
        echo "go version stable is not installed"
        return 0
      fi
      version="$(cat ~/.gimme/versions/stable)" || return 1
      rm ~/.gimme/versions/stable || return 1
    else
      version="$1"
    fi
    if ! [ $(ls ~/.gimme/versions | grep "$version") ] ; then
      echo "go version $version is not installed"
      return 0
    else
      rm -r ~/.gimme/versions/go"$version"* || return 1
      rm ~/.gimme/envs/go"$version"* || return 1
    fi
    return 0
  fi
}

# gimme completion
__gimme_completion() {
  local version_1 version_2 version_3
  version_1="1.8.3"
  version_2="1.7.6"
  version_3="1.6.4"
  local context state state_descr line
  typeset -a go_versions
  go_versions+=(
  '(help version force list tip '$version_1' '$version_2' '$version_3' \
    )stable[install latest stable go version]'
  '(help version force list stable '$version_1' '$version_2' '$version_3' \
    )tip[install development version (master branch) of go]'
  '(help version force list stable tip '$version_2' '$version_3' \
    )'$version_1'[install go version '$version_1']'
  '(help version force list stable tip '$version_1' '$version_3' \
    )'$version_2'[install go version '$version_2']'
  '(help version force list stable tip '$version_1' '$version_2' \
    )'$version_3'[install go version '$version_3']'
  )
  typeset -a flags
  flags+=(
  '(version force list stable tip '$version_1' '$version_2' \
    '$version_3')help[show help text and exit]'
  '(help force list stable tip '$version_1' '$version_2' \
    '$version_3')version[show the gimme version only and exit]'
    '(help version list)force[remove the existing go installation if present prior to install]'
    '(help version force stable tip '$version_1' '$version_2' \
    '$version_3')list[list installed go versions and exit]'
    )
      _values -w 'flags go_versions' ${flags[@]} ${go_versions[@]}
      return
}

__load-go_completion() {
  local version_1 version_2 version_3
  version_1="1.8.3"
  version_2="1.7.6"
  version_3="1.6.4"
  local context state state_descr line
  typeset -a go_versions
  go_versions+=(
  '(tip '$version_1' '$version_2' '$version_3' \
    )stable[latest stable go version]'
  '(stable '$version_1' '$version_2' '$version_3' \
    )tip[development version (master branch) of go]'
  '(stable tip '$version_2' '$version_3' \
    )'$version_1'[go version '$version_1']'
  '(stable tip '$version_1' '$version_3' \
    )'$version_2'[go version '$version_2']'
  '(stable tip '$version_1' '$version_2' \
    )'$version_3'[go version '$version_3']'
  )
  _values 'go_versions' ${go_versions[@]}
}

__remove-go_completion() {
  local context state state_descr line
  typeset -a installed_versions
  if [ "$(ls ~/.gimme/versions | grep stable)" ] ; then
    installed_versions+=('stable')
  fi
  if [ -d ~/.gimme/versions/go ] ; then
    installed_versions+=('tip')
  fi
  installed_versions+=($(ls ~/.gimme/versions | egrep -oZ '[0-9].[0-9].[0-9]'))
  _values -w 'installed_versions' ${installed_versions[@]}
}

compdef __gimme_completion gimme
compdef __load-go_completion load-go
compdef __remove-go_completion remove-go
