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
  elif [[ -h /opt/homebrew/opt/chruby ]]; then
    _brew_prefix="/opt/homebrew/opt/chruby"
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
