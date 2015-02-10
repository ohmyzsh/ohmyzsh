# Uses the command-not-found package zsh support
# as seen in http://www.porcheron.info/command-not-found-for-zsh/
# this is installed in Ubuntu

[[ -e /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

# Arch Linux command-not-found support, you must have package pkgfile installed
# https://wiki.archlinux.org/index.php/Pkgfile#.22Command_not_found.22_hook
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

# brew-command-not-found script for OS X
#
# Original author: Baptiste Fontaine
# URL: https://github.com/bfontaine/brew-command-not-found
# License: MIT
# Version: 0.1.1
if [ ! -z "$(which brew)" ]; then
    local formula_path="$(brew --prefix)/Library/Formula"

    command_not_found_handler() {

        # <from Linux Journal>
        #   http://www.linuxjournal.com/content/bash-command-not-found

        export TEXTDOMAIN=command-not-found

        # do not run when inside Midnight Commander or within a Pipe
        if test -n "$MC_SID" -o ! -t 1 ; then
            return 127
        fi

        # </from Linux Journal>

        local f=$(grep -lI -E "bin\.install..*\b$1\b(\"|')" $formula_path/*.rb 2>/dev/null)

        if [ -z "$f" ]; then
            return 127
        fi

        f=${f##*/}
        f=${f%%.rb}

        echo "The program '$1' is currently not installed. You can install it by typing:"
        echo "  brew install $f"
    }
fi
