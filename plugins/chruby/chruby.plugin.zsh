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

_homebrew-installed() {
    whence brew &> /dev/null
}

_ruby-build_installed() {
    whence ruby-build &> /dev/null
}

_ruby-install-installed() {
    whence ruby-install &> /dev/null
}

# Simple definition completer for ruby-build
if _ruby-build_installed; then
    _ruby-build() {
        compadd $(ruby-build --definitions)
    }
    compdef _ruby-build ruby-build
fi

_source_from_omz_settings() {
    local _chruby_path
    local _chruby_auto
    
    zstyle -s :omz:plugins:chruby path _chruby_path
    zstyle -s :omz:plugins:chruby auto _chruby_auto

    if [[ -r "$_chruby_path" ]]; then
        source "$_chruby_path"
    fi

    if [[ -r "$_chruby_auto" ]]; then
        source "$_chruby_auto"
    fi
}

function () {
    local _chruby_homebrew_prefix="$(brew --prefix chruby) &> /dev/null"

    if _homebrew-installed && [[ -r "$_chruby_homebrew_prefix" ]] ; then
        source "${_chruby_homebrew_prefix}/share/chruby/chruby.sh"
        source "${_chruby_homebrew_prefix}/share/chruby/auto.sh"
    elif [[ -r "/usr/local/share/chruby/chruby.sh" ]] ; then
        source /usr/local/share/chruby/chruby.sh
        source /usr/local/share/chruby/auto.sh
    else
        _source_from_omz_settings
    fi
}

function ensure_chruby() {
    $(whence chruby)
}

function current_ruby() {
    local _ruby="$(chruby | grep \* | tr -d '* ')"
    if [[ -n "$_ruby" ]]; then
        echo "$_ruby"
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
