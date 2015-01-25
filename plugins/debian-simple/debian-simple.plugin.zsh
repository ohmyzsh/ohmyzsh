# Authors:
# https://github.com/casaper
#
# Derived from debian
###### Reason #########################
## To me this plugin does to much plus I happen to be 
## punished with a terrible memory.
## So first I will not be able to remember “age” and aliases like
## “adu” are simply dangerous for alzhimer minds like mine ;).

##### aptitude or apt-get ###########################
## you can set “export apt_perf='aptitude' in ~/.zshrc in order to use 
## aptitude with this plugin, if you prefer.
if [[ $apt_perf = 'aptitude' && -e $( which -p aptitude 2>&1 ) ]]; then
    apt_pref='aptitude'
else
    apt_pref='apt-get'
fi

# Use sudo by default if it's installed
if [[ -e $( which -p sudo 2>&1 ) ]]; then
    use_sudo=1
fi

# Some self-explanatory aliases
alias apt-search="apt-cache search"
alias aps='aptitude search'
alias as="aptitude -F \"* %p -> %d \n(%v/%V)\" \
		--no-gui --disable-columns search"	# search package

# apt-file
alias apt-file-search='apt-file search --regexp'


# These are apt-get only
alias apt-source='apt-get source'
alias apt-cache-policy='apt-cache policy'

# superuser operations ######################################################
if [[ $use_sudo -eq 1 ]]; then
# commands using sudo #######
    alias apt-autoclean='sudo $apt_pref autoclean'
    alias apt-build-dep='sudo $apt_pref build-dep'
    alias apt-clean='sudo $apt_pref clean'
    alias apt-update='sudo $apt_pref update'
    alias apt-upgrade='sudo $apt_pref update && sudo $apt_pref upgrade'
    alias apt-dist-upgrade='sudo $apt_pref update && sudo $apt_pref dist-upgrade'
    alias apt-file-upgrade='sudo apt-file update'
    alias apt-upgrade-only='sudo $apt_pref upgrade'
    alias apt-install='sudo $apt_pref install'
    # Install all packages given on the command line while using only the first word of each line:
    # apt-search ... | ail
    alias apt-install-list="sed -e 's/  */ /g' -e 's/ *//' | cut -s -d ' ' -f 1 | "' xargs sudo $apt_pref install'
    alias apt-purge='sudo $apt_pref purge'
    alias apt-remove='sudo $apt_pref remove'

    # apt-get only
    alias apt-deselect-upgrade='sudo apt-get dselect-upgrade'

    # Install all .deb files in the current directory.
    # Warning: you will need to put the glob in single quotes if you use:
    # glob_subst
    alias dpkg-install-alldeb-pwd='sudo dpkg -i ./*.deb'
    alias dpkg-install='sudo dpkg -i'

    # Remove ALL kernel images and headers EXCEPT the one in use
    alias kclean='sudo aptitude remove -P ?and(~i~nlinux-(ima|hea) \
        ?not(~n`uname -r`))'


# commands using su #########
else
    alias apt-autoclean='su -ls \'$apt_pref autoclean\' root'
    apt-build-dep() {
        cmd="su -lc '$apt_pref build-dep $@' root"
        print "$cmd"
        eval "$cmd"
    }
    alias apt-clean='su -ls \'$apt_pref clean\' root'
    alias apt-update='su -lc \'$apt_pref update\' root'
    alias apt-upgrade='su -lc \'$apt_pref update && aptitude safe-upgrade\' root'
    alias apt-dist-upgrade='su -lc \'$apt_pref update && aptitude dist-upgrade\' root'
    alias apt-file-upgrade='su -lc "apt-file update"'
    alias apt-upgrade-only='su -lc \'$apt_pref safe-upgrade\' root'
    apt-install() {
        cmd="su -lc 'aptitude -P install $@' root"
        print "$cmd"
        eval "$cmd"
    }
    apt-purge() {
        cmd="su -lc '$apt_pref -P purge $@' root"
        print "$cmd"
        eval "$cmd"
    }
    apt-remove() {
        cmd="su -lc '$apt_pref -P remove $@' root"
        print "$cmd"
        eval "$cmd"
    }

    # Install all .deb files in the current directory
    # Assumes glob_subst is off
    alias dpkg-install-alldeb-pwd='su -lc "dpkg -i ./*.deb" root'
    alias dpkg-install='su -lc "dpkg -i" root'

    # Remove ALL kernel images and headers EXCEPT the one in use
    alias kclean='su -lc '\''aptitude remove -P ?and(~i~nlinux-(ima|hea) \
        ?not(~n`uname -r`))'\'' root'
fi

# Completion ################################################################

#
# Registers a compdef for $1 that calls $apt_pref with the commands $2
# To do that it creates a new completion function called _apt_pref_$2
#
apt_pref_compdef() {
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

apt_pref_compdef apt-autoclean "autoclean"
apt_pref_compdef apt-build-dep "build-dep"
apt_pref_compdef apt-clean  "clean"
apt_pref_compdef apt-update  "update"
apt_pref_compdef apt-file-upgrade "update"
apt_pref_compdef apt-upgrade-only  "upgrade"
apt_pref_compdef apt-install  "install"
apt_pref_compdef apt-install-list "install"
apt_pref_compdef apt-purge  "purge"
apt_pref_compdef apt-remove  "remove"
apt_pref_compdef apt-deselect-upgrade "dselect-upgrade"


# Prints apt history
# Usage:
#   apt-history install
#   apt-history upgrade
#   apt-history remove
#   apt-history rollback
#   apt-history list
# Based On: http://linuxcommando.blogspot.com/2008/08/how-to-show-apt-log-history.html
apt-history () {
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
      zcat $(ls -rt /var/log/dpkg*)
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


# List packages by size
function apt-list-packages-by-size {
    dpkg-query -W --showformat='${Installed-Size} ${Package} ${Status}\n' | \
    grep -v deinstall | \
    sort -n | \
    awk '{print $1" "$2}'
}

