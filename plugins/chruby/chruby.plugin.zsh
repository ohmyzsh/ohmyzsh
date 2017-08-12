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

function () {
    local _path
    local _auto
    local _prefix="/usr/local/share/chruby"

    # Honor explicit user preference
    zstyle -s :omz:plugins:chruby path _path
    zstyle -s :omz:plugins:chruby auto _auto

    # Default to /usr/local/share/chruby if either is not defined
    [[ -r "$_path" ]] || _path="${_prefix}/chruby.sh"
    [[ -r "$_auto" ]] || _auto="${_prefix}/auto.sh"

    # Fall back on homebrew
    if [[ ! ( -r "$_path" && -r "$_auto" ) ]]; then
        if _homebrew-installed; then
            _prefix="$(brew --prefix chruby 2> /dev/null)/share/chruby"
            [[ -r "$_path" ]] || _path="${_prefix}/chruby.sh"
            [[ -r "$_auto" ]] || _auto="${_prefix}/auto.sh"
        fi
    fi

    if [[ -r "$_path" ]]; then
        source "$_path"
    fi

    if [[ -r "$_auto" ]]; then
        source "$_auto"
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
