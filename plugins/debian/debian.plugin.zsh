# Use aptitude or apt if installed, fallback is apt-get
# You can just set apt_pref='apt-get' to override it.

if [[ -z $apt_pref || -z $apt_upgr ]]; then
    if [[ -e $commands[aptitude] ]]; then
        apt_pref='aptitude'
        apt_upgr='safe-upgrade'
    elif [[ -e $commands[apt] ]]; then
        apt_pref='apt'
        apt_upgr='upgrade'
    else
        apt_pref='apt-get'
        apt_upgr='upgrade'
    fi
fi

# Use sudo by default if it's installed
if [[ -e $commands[sudo] ]]; then
    use_sudo=1
fi

# Aliases ###################################################################
# These are for more obscure uses of apt-get and aptitude that aren't covered
# below.
alias age='apt-get'
alias api='aptitude'

# Some self-explanatory aliases
alias acs="apt-cache search"
alias aps='aptitude search'
alias as="aptitude -F '* %p -> %d \n(%v/%V)' --no-gui --disable-columns search"

# apt-file
alias afs='apt-file search --regexp'


# These are apt-get only
alias asrc='apt-get source'
alias app='apt-cache policy'

# superuser operations ######################################################
if [[ $use_sudo -eq 1 ]]; then
# commands using sudo #######
    alias aac="sudo $apt_pref autoclean"
    alias abd="sudo $apt_pref build-dep"
    alias ac="sudo $apt_pref clean"
    alias ad="sudo $apt_pref update"
    alias adg="sudo $apt_pref update && sudo $apt_pref $apt_upgr"
    alias adu="sudo $apt_pref update && sudo $apt_pref dist-upgrade"
    alias afu="sudo apt-file update"
    alias au="sudo $apt_pref $apt_upgr"
    alias ai="sudo $apt_pref install"
    # Install all packages given on the command line while using only the first word of each line:
    # acse ... | ail

    alias ail="sed -e 's/  */ /g' -e 's/ *//' | cut -s -d ' ' -f 1 | xargs sudo $apt_pref install"
    alias ap="sudo $apt_pref purge"
    alias aar="sudo $apt_pref autoremove"

    # apt-get only
    alias ads="sudo apt-get dselect-upgrade"

    # apt only
    alias alu="sudo apt update && apt list -u && sudo apt upgrade"

    # Install all .deb files in the current directory.
    # Warning: you will need to put the glob in single quotes if you use:
    # glob_subst
    alias dia="sudo dpkg -i ./*.deb"
    alias di="sudo dpkg -i"

    # Remove ALL kernel images and headers EXCEPT the one in use
    alias kclean='sudo aptitude remove -P "?and(~i~nlinux-(ima|hea) ?not(~n$(uname -r)))"'


# commands using su #########
else
    alias aac="su -ls '$apt_pref autoclean' root"
    function abd() {
        cmd="su -lc '$apt_pref build-dep $@' root"
        print "$cmd"
        eval "$cmd"
    }
    alias ac="su -ls '$apt_pref clean' root"
    alias ad="su -lc '$apt_pref update' root"
    alias adg="su -lc '$apt_pref update && $apt_pref $apt_upgr' root"
    alias adu="su -lc '$apt_pref update && $apt_pref dist-upgrade' root"
    alias afu="su -lc 'apt-file update'"
    alias au="su -lc '$apt_pref $apt_upgr' root"
    function ai() {
        cmd="su -lc '$apt_pref install $@' root"
        print "$cmd"
        eval "$cmd"
    }
    function ap() {
        cmd="su -lc '$apt_pref purge $@' root"
        print "$cmd"
        eval "$cmd"
    }
    function aar() {
        cmd="su -lc '$apt_pref autoremove $@' root"
        print "$cmd"
        eval "$cmd"
    }
    # Install all .deb files in the current directory
    # Assumes glob_subst is off
    alias dia='su -lc "dpkg -i ./*.deb" root'
    alias di='su -lc "dpkg -i" root'

    # Remove ALL kernel images and headers EXCEPT the one in use
    alias kclean='su -lc "aptitude remove -P \"?and(~i~nlinux-(ima|hea) ?not(~n$(uname -r)))\"" root'
fi

# Completion ################################################################

#
# Registers a compdef for $1 that calls $apt_pref with the commands $2
# To do that it creates a new completion function called _apt_pref_$2
#
function apt_pref_compdef() {
    local f fb
    f="_apt_pref_${2}"

    eval "function ${f}() {
        shift words;
        service=\"\$apt_pref\";
        words=(\"\$apt_pref\" '$2' \$words);
        ((CURRENT++))
        test \"\${apt_pref}\" = 'aptitude' && _aptitude || _apt
    }"

    compdef "$f" "$1"
}

apt_pref_compdef aac "autoclean"
apt_pref_compdef abd "build-dep"
apt_pref_compdef ac  "clean"
apt_pref_compdef ad  "update"
apt_pref_compdef afu "update"
apt_pref_compdef au  "$apt_upgr"
apt_pref_compdef ai  "install"
apt_pref_compdef ail "install"
apt_pref_compdef ap  "purge"
apt_pref_compdef aar  "autoremove"
apt_pref_compdef ads "dselect-upgrade"

# Misc. #####################################################################
# print all installed packages
alias allpkgs='aptitude search -F "%p" --disable-columns ~i'

# Create a basic .deb package
alias mydeb='time dpkg-buildpackage -rfakeroot -us -uc'


# Functions #################################################################
# create a simple script that can be used to 'duplicate' a system
function apt-copy() {
    print '#!/bin/sh'"\n" > apt-copy.sh

    cmd='$apt_pref install'

    for p in ${(f)"$(aptitude search -F "%p" --disable-columns \~i)"}; {
        cmd="${cmd} ${p}"
    }

    print $cmd "\n" >> apt-copy.sh

    chmod +x apt-copy.sh
}

# Prints apt history
# Usage:
#   apt-history install
#   apt-history upgrade
#   apt-history remove
#   apt-history rollback
#   apt-history list
# Based On: https://linuxcommando.blogspot.com/2008/08/how-to-show-apt-log-history.html
function apt-history() {
  case "$1" in
    install)
      zgrep --no-filename 'install ' $(ls -rt /var/log/dpkg*)
      ;;
    upgrade|remove)
      zgrep --no-filename $1 $(ls -rt /var/log/dpkg*)
      ;;
    rollback)
      zgrep --no-filename upgrade $(ls -rt /var/log/dpkg*) | \
        grep "$2" -A10000000 | \
        grep "$3" -B10000000 | \
        awk '{print $4"="$5}'
      ;;
    list)
      zgrep --no-filename '' $(ls -rt /var/log/dpkg*)
      ;;
    *)
      echo "Parameters:"
      echo " install - Lists all packages that have been installed."
      echo " upgrade - Lists all packages that have been upgraded."
      echo " remove - Lists all packages that have been removed."
      echo " rollback - Lists rollback information."
      echo " list - Lists all contains of dpkg logs."
      ;;
  esac
}

# Kernel-package building shortcut
function kerndeb() {
    # temporarily unset MAKEFLAGS ( '-j3' will fail )
    MAKEFLAGS=$( print - $MAKEFLAGS | perl -pe 's/-j\s*[\d]+//g' )
    print '$MAKEFLAGS set to '"'$MAKEFLAGS'"
    appendage='-custom' # this shows up in $(uname -r )
    revision=$(date +"%Y%m%d") # this shows up in the .deb file name

    make-kpkg clean

    time fakeroot make-kpkg --append-to-version "$appendage" --revision \
        "$revision" kernel_image kernel_headers
}

# List packages by size
function apt-list-packages() {
    dpkg-query -W --showformat='${Installed-Size} ${Package} ${Status}\n' | \
    grep -v deinstall | \
    sort -n | \
    awk '{print $1" "$2}'
}
