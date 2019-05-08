# Authors:
# https://github.com/AlexBio
# https://github.com/dbb
# https://github.com/Mappleconfusers
# https://github.com/trinaldi
# Nicolas Jonas nextgenthemes.com
# https://github.com/loctauxphilippe
# https://github.com/HaraldNordgren
#
# Debian, Ubuntu and friends related zsh aliases and functions for zsh

(( $+commands[apt] )) && APT=apt || APT=apt-get

alias acs='apt-cache search'
compdef _acs acs='apt-cache search'

alias afs='apt-file search --regexp'
compdef _afs afs='apt-file search --regexp'

# These are apt/apt-get only
alias ags="$APT source"   # asrc
compdef _ags ags="$APT source"

alias acp='apt-cache policy' # app
compdef _acp acp='apt-cache policy'

#List all installed packages
alias agli='apt list --installed'
compdef _agli agli='apt list --installed'

# superuser operations ######################################################

# List available updates only
alias aglu='sudo apt-get -u upgrade --assume-no'
compdef _aglu aglu='sudo apt-get -u upgrade --assume-no'

alias afu='sudo apt-file update'
compdef _afu afu='sudo apt-file update'

alias ppap='sudo ppa-purge'
compdef _ppap ppap='sudo ppa-purge'

alias ag="sudo $APT"               # age - but without sudo
alias aga="sudo $APT autoclean"    # aac
alias agb="sudo $APT build-dep"    # abd
alias agc="sudo $APT clean"        # adc
alias agd="sudo $APT dselect-upgrade" # ads
alias agi="sudo $APT install"      # ai
alias agp="sudo $APT purge"        # ap
alias agr="sudo $APT remove"       # ar
alias agu="sudo $APT update"       # ad
alias agud="sudo $APT update && sudo $APT dist-upgrade" #adu
alias agug="sudo $APT upgrade"     # ag
alias aguu="sudo $APT update && sudo $APT upgrade"      #adg
alias agar="sudo $APT autoremove"

compdef _ag ag="sudo $APT"
compdef _aga aga="sudo $APT autoclean"
compdef _agb agb="sudo $APT build-dep"
compdef _agc agc="sudo $APT clean"
compdef _agd agd="sudo $APT dselect-upgrade"
compdef _agi agi="sudo $APT install"
compdef _agp agp="sudo $APT purge"
compdef _agr agr="sudo $APT remove"
compdef _agu agu="sudo $APT update"
compdef _agud agud="sudo $APT update && sudo $APT dist-upgrade"
compdef _agug agug="sudo $APT upgrade"
compdef _aguu aguu="sudo $APT update && sudo $APT upgrade"
compdef _agar agar="sudo $APT autoremove"

# Remove ALL kernel images and headers EXCEPT the one in use
alias kclean='sudo aptitude remove -P ?and(~i~nlinux-(ima|hea) \
	?not(~n`uname -r`))'

# Misc. #####################################################################
# print all installed packages
alias allpkgs='dpkg --get-selections | grep -v deinstall'

# Create a basic .deb package
alias mydeb='time dpkg-buildpackage -rfakeroot -us -uc'

# apt-add-repository with automatic install/upgrade of the desired package
# Usage: aar ppa:xxxxxx/xxxxxx [packagename]
# If packagename is not given as 2nd argument the function will ask for it and guess the default by taking
# the part after the / from the ppa name which is sometimes the right name for the package you want to install
aar() {
	if [ -n "$2" ]; then
		PACKAGE=$2
	else
		read "PACKAGE?Type in the package name to install/upgrade with this ppa [${1##*/}]: "
	fi
	
	if [ -z "$PACKAGE" ]; then
		PACKAGE=${1##*/}
	fi
	
	sudo apt-add-repository $1 && sudo $APT update
	sudo $APT install $PACKAGE
}

# Prints apt history
# Usage:
#   apt-history install
#   apt-history upgrade
#   apt-history remove
#   apt-history rollback
#   apt-history list
# Based On: https://linuxcommando.blogspot.com/2008/08/how-to-show-apt-log-history.html
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
kerndeb () {
    # temporarily unset MAKEFLAGS ( '-j3' will fail )
    MAKEFLAGS=$( print - $MAKEFLAGS | perl -pe 's/-j\s*[\d]+//g' )
    print '$MAKEFLAGS set to '"'$MAKEFLAGS'"
	appendage='-custom' # this shows up in $ (uname -r )
    revision=$(date +"%Y%m%d") # this shows up in the .deb file name

    make-kpkg clean

    time fakeroot make-kpkg --append-to-version "$appendage" --revision \
        "$revision" kernel_image kernel_headers
}

# List packages by size
function apt-list-packages {
    dpkg-query -W --showformat='${Installed-Size} ${Package} ${Status}\n' | \
    grep -v deinstall | \
    sort -n | \
    awk '{print $1" "$2}'
}
