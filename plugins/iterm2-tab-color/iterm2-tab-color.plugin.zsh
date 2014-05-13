# Written by Wade Simmons
# https://github.com/wadey
#
# iTerm2 tab color commands
# http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes

if [[ -n "$ITERM_SESSION_ID" ]]; then
    tab-color() {
        echo -ne "\033]6;1;bg;red;brightness;$1\a"
        echo -ne "\033]6;1;bg;green;brightness;$2\a"
        echo -ne "\033]6;1;bg;blue;brightness;$3\a"
    }
    tab-red() { tab-color 255 0 0 }
    tab-green() { tab-color 0 255 0 }
    tab-blue() { tab-color 0 0 255 }
    tab-orange() { tab-color 255 128 0 }

    tab-reset() { echo -ne "\033]6;1;bg;*;default\a" }

    function iterm2_precmd() {
        tab-reset
    }

    function iterm2_preexec() {
        # Are we using SSH?
        if [[ "$1" =~ "^ssh " ]]; then
            # Display RED on any kind of prod(uction) servers
            if [[ "$*" =~ "prod" ]]; then
                tab-red
            else
                if [[ "$*" =~ "dev" ]]; then
                    tab-green
                else
                    tab-orange
                fi
            fi
        fi
    }

    autoload -U add-zsh-hook
    add-zsh-hook precmd  iterm2_precmd
    add-zsh-hook preexec iterm2_preexec
fi
