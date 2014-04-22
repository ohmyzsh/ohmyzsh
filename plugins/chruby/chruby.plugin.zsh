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
    brew --prefix chruby &> /dev/null
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

    if _chruby_path && [[ -r _chruby_path ]]; then
        source ${_chruby_path}
    fi

    if _chruby_auto && [[ -r _chruby_auto ]]; then
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
