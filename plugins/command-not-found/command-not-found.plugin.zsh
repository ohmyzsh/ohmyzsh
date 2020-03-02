# Uses the command-not-found package zsh support
# as seen in https://www.porcheron.info/command-not-found-for-zsh/
# this is installed in Ubuntu

[[ -e /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

# Arch Linux command-not-found support, you must have package pkgfile installed
# https://wiki.archlinux.org/index.php/Pkgfile#.22Command_not_found.22_hook
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

# Fedora command-not-found support
if [ -f /usr/libexec/pk-command-not-found ]; then
    command_not_found_handler () {
        runcnf=1
        retval=127
        [ ! -S /var/run/dbus/system_bus_socket ] && runcnf=0
        [ ! -x /usr/libexec/packagekitd ] && runcnf=0
        if [ $runcnf -eq 1 ]
            then
            /usr/libexec/pk-command-not-found $@
            retval=$?
        fi
        return $retval
    }
fi

# OSX command-not-found support
# https://github.com/Homebrew/homebrew-command-not-found
if [[ -s '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh' ]]; then
    source '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh'
fi

# NixOS command-not-found support
if [ -x /run/current-system/sw/bin/command-not-found ]; then
    command_not_found_handler () {
        /run/current-system/sw/bin/command-not-found $@
    }
fi
