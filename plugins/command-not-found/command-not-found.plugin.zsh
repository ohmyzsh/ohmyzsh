<<<<<<< HEAD
# Uses the command-not-found package zsh support
# as seen in http://www.porcheron.info/command-not-found-for-zsh/
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
=======
## Platforms with a built-in command-not-found handler init file

for file (
  # Arch Linux. Must have pkgfile installed: https://wiki.archlinux.org/index.php/Pkgfile#Command_not_found
  /usr/share/doc/pkgfile/command-not-found.zsh
  # macOS (M1 and classic Homebrew): https://github.com/Homebrew/homebrew-command-not-found
  /opt/homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh
  /usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh
); do
  if [[ -r "$file" ]]; then
    source "$file"
    unset file
    return 0
  fi
done
unset file


## Platforms with manual command_not_found_handler() setup

# Debian and derivatives: https://launchpad.net/ubuntu/+source/command-not-found
if [[ -x /usr/lib/command-not-found || -x /usr/share/command-not-found/command-not-found ]]; then
  command_not_found_handler() {
    if [[ -x /usr/lib/command-not-found ]]; then
      /usr/lib/command-not-found -- "$1"
      return $?
    elif [[ -x /usr/share/command-not-found/command-not-found ]]; then
      /usr/share/command-not-found/command-not-found -- "$1"
      return $?
    else
      printf "zsh: command not found: %s\n" "$1" >&2
      return 127
    fi
  }
fi

# Fedora: https://fedoraproject.org/wiki/Features/PackageKitCommandNotFound
if [[ -x /usr/libexec/pk-command-not-found ]]; then
  command_not_found_handler() {
    if [[ -S /var/run/dbus/system_bus_socket && -x /usr/libexec/packagekitd ]]; then
      /usr/libexec/pk-command-not-found "$@"
      return $?
    fi

    printf "zsh: command not found: %s\n" "$1" >&2
    return 127
  }
fi

# NixOS: https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/programs/command-not-found
if [[ -x /run/current-system/sw/bin/command-not-found ]]; then
  command_not_found_handler() {
    /run/current-system/sw/bin/command-not-found "$@"
  }
fi

# Termux: https://github.com/termux/command-not-found
if [[ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]]; then
  command_not_found_handler() {
    /data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
  }
fi

# SUSE and derivates: https://www.unix.com/man-page/suse/1/command-not-found/
if [[ -x /usr/bin/command-not-found ]]; then
  command_not_found_handler() {
    /usr/bin/command-not-found "$1"
  }
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
fi
