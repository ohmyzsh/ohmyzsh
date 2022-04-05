<<<<<<< HEAD
#
# INSTRUCTIONS
#
#  With either a manual or brew installed chruby things should just work.
#
#  If you'd prefer to specify an explicit path to load chruby from
#  you can set variables like so:
#
#    zstyle :omz:plugins:chruby path /local/path/to/chruby.sh
#    zstyle :omz:plugins:chruby auto /local/path/to/auto.sh
# 
# TODO
#  - autodetermine correct source path on non OS X systems
#  - completion if ruby-install exists

# rvm and rbenv plugins also provide this alias
alias rubies='chruby'

local _chruby_path
local _chruby_auto

_homebrew-installed() {
    whence brew &> /dev/null
}

_chruby-from-homebrew-installed() {
  [ -r $(brew --prefix chruby)] &> /dev/null
}

_ruby-build_installed() {
    whence ruby-build &> /dev/null
}

_ruby-install-installed() {
    whence ruby-install &> /dev/null
}

# Simple definition completer for ruby-build
if _ruby-build_installed; then
    _ruby-build() { compadd $(ruby-build --definitions) }
    compdef _ruby-build ruby-build
fi

_source_from_omz_settings() {
    zstyle -s :omz:plugins:chruby path _chruby_path
    zstyle -s :omz:plugins:chruby auto _chruby_auto

    if ${_chruby_path} && [[ -r ${_chruby_path} ]]; then
        source ${_chruby_path}
    fi

    if ${_chruby_auto} && [[ -r ${_chruby_auto} ]]; then
        source ${_chruby_auto}
    fi
}

_chruby_dirs() {
    chrubydirs=($HOME/.rubies/ $PREFIX/opt/rubies)
    for dir in chrubydirs; do
        if [[ -d $dir ]]; then
            RUBIES+=$dir
        fi
    done
}

if _homebrew-installed && _chruby-from-homebrew-installed ; then
    source $(brew --prefix chruby)/share/chruby/chruby.sh
    source $(brew --prefix chruby)/share/chruby/auto.sh
    _chruby_dirs
elif [[ -r "/usr/local/share/chruby/chruby.sh" ]] ; then
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh
    _chruby_dirs
else
    _source_from_omz_settings
    _chruby_dirs
fi

function ensure_chruby() {
    $(whence chruby)
}

function current_ruby() {
    local _ruby
    _ruby="$(chruby |grep \* |tr -d '* ')"
    if [[ $(chruby |grep -c \*) -eq 1 ]]; then
        echo ${_ruby}
    else
        echo "system"
    fi
}

function chruby_prompt_info() {
    echo "$(current_ruby)"
}

# complete on installed rubies
_chruby() { compadd $(chruby | tr -d '* ') }
compdef _chruby chruby
=======
## load chruby from different locations

_source-from-omz-settings() {
  local _chruby_path _chruby_auto
  
  zstyle -s :omz:plugins:chruby path _chruby_path || return 1
  zstyle -s :omz:plugins:chruby auto _chruby_auto || return 1

  if [[ -r ${_chruby_path} ]]; then
    source ${_chruby_path}
  fi

  if [[ -r ${_chruby_auto} ]]; then
    source ${_chruby_auto}
  fi
}

_source-from-homebrew() {
  (( $+commands[brew] )) || return 1

  local _brew_prefix
  # check default brew prefix
  if [[ -h /usr/local/opt/chruby ]];then
    _brew_prefix="/usr/local/opt/chruby"
  else
    # ok , it is not default prefix 
    # this call to brew is expensive ( about 400 ms ), so at least let's make it only once
    _brew_prefix=$(brew --prefix chruby)
  fi

  [[ -r "$_brew_prefix" ]] || return 1

  source $_brew_prefix/share/chruby/chruby.sh
  source $_brew_prefix/share/chruby/auto.sh
}

_load-chruby-dirs() {
  local dir
  for dir in "$HOME/.rubies" "$PREFIX/opt/rubies"; do
    if [[ -d "$dir" ]]; then
      RUBIES+=("$dir")
    fi
  done
}

# Load chruby
if _source-from-omz-settings; then
  _load-chruby-dirs
elif [[ -r "/usr/local/share/chruby/chruby.sh" ]] ; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
  _load-chruby-dirs
elif _source-from-homebrew; then
  _load-chruby-dirs
fi

unfunction _source-from-homebrew _source-from-omz-settings _load-chruby-dirs


## chruby utility functions and aliases

# rvm and rbenv plugins also provide this alias
alias rubies='chruby'

function current_ruby() {
  local ruby
  ruby="$(chruby | grep \* | tr -d '* ')"
  if [[ $(chruby | grep -c \*) -eq 1 ]]; then
    echo ${ruby}
  else
    echo "system"
  fi
}

function chruby_prompt_info() {
  echo "${$(current_ruby):gs/%/%%}"
}

# Complete chruby command with installed rubies
_chruby() {
  compadd $(chruby | tr -d '* ')
  if PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" command ruby &>/dev/null; then
    compadd system
  fi
}

compdef _chruby chruby


# Simple definition completer for ruby-build
if command ruby-build &> /dev/null; then
  _ruby-build() { compadd $(ruby-build --definitions) }
  compdef _ruby-build ruby-build
fi
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
