(( $+commands[apt] )) && APT=apt || APT=apt-get

alias acs='apt-cache search'

alias afs='apt-file search --regexp'

# These are apt/apt-get only
alias ags="$APT source"

alias acp='apt-cache policy'

#List all installed packages
alias agli='apt list --installed'

# List available updates only
alias aglu='apt list --upgradable'

# superuser operations ######################################################

alias afu='sudo apt-file update'

alias ppap='sudo ppa-purge'

alias age="sudo $APT"
alias aga="sudo $APT autoclean"
alias agb="sudo $APT build-dep"
alias agc="sudo $APT clean"
alias agd="sudo $APT dselect-upgrade"
alias agi="sudo $APT install"
alias agp="sudo $APT purge"
alias agr="sudo $APT remove"
alias agu="sudo $APT update"
alias agud="sudo $APT update && sudo $APT dist-upgrade"
alias agug="sudo $APT upgrade"
alias aguu="sudo $APT update && sudo $APT upgrade"
alias agar="sudo $APT autoremove"


# Remove ALL kernel images and headers EXCEPT the one in use
alias kclean='sudo aptitude remove -P ?and(~i~nlinux-(ima|hea) ?not(~n`uname -r`))'

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
  appendage='-custom' # this shows up in $(uname -r)
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

function ubuntu-clist {
  echo These are apt/apt-get only:
  echo $(tput setaf 2)ags$(tput sgr 0) = $(tput setaf 3)"apt source"$(tput sgr 0)
  echo ""
  echo Misc.
  echo $(tput setaf 2)acs$(tput sgr 0) = $(tput setaf 3)'apt-cache search'$(tput sgr 0)
  echo $(tput setaf 2)afs$(tput sgr 0) = $(tput setaf 3)'apt-file search --regexp'$(tput sgr 0)
  echo $(tput setaf 2)acp$(tput sgr 0) = $(tput setaf 3)'apt-cache policy'$(tput sgr 0)
  echo ""
  echo List all installed packages
  echo $(tput setaf 2)agli$(tput sgr 0) = $(tput setaf 3)'apt list --installed'$(tput sgr 0)
  echo ""
  echo List available updates only
  echo $(tput setaf 2)aglu$(tput sgr 0) = $(tput setaf 3)'apt list --upgradable'$(tput sgr 0)
  echo ""
  echo !Superuser Operations
  echo $(tput setaf 2)afu$(tput sgr 0) = $(tput setaf 3)'sudo apt-file update'$(tput sgr 0)
  echo $(tput setaf 2)ppap$(tput sgr 0) = $(tput setaf 3)'sudo ppa-purge'$(tput sgr 0)
  echo $(tput setaf 2)age$(tput sgr 0) = $(tput setaf 3)"sudo apt"$(tput sgr 0)
  echo $(tput setaf 2)aga$(tput sgr 0) = $(tput setaf 3)"sudo apt autoclean"$(tput sgr 0)
  echo $(tput setaf 2)agb$(tput sgr 0) = $(tput setaf 3)"sudo apt build-dep"$(tput sgr 0)
  echo $(tput setaf 2)agc$(tput sgr 0) = $(tput setaf 3)"sudo apt clean"$(tput sgr 0)
  echo $(tput setaf 2)agd$(tput sgr 0) = $(tput setaf 3)"sudo apt dselect-upgrade"$(tput sgr 0)
  echo $(tput setaf 2)agi$(tput sgr 0) = $(tput setaf 3)"sudo apt install"$(tput sgr 0)
  echo $(tput setaf 2)agp$(tput sgr 0) = $(tput setaf 3)"sudo apt purge"$(tput sgr 0)
  echo $(tput setaf 2)agr$(tput sgr 0) = $(tput setaf 3)"sudo apt remove"$(tput sgr 0)
  echo $(tput setaf 2)agu$(tput sgr 0) = $(tput setaf 3)"sudo apt update"$(tput sgr 0)
  echo $(tput setaf 2)agud$(tput sgr 0) = $(tput setaf 3)"sudo apt update && sudo apt dist-upgrade"$(tput sgr 0)
  echo $(tput setaf 2)agug$(tput sgr 0) = $(tput setaf 3)"sudo apt upgrade"$(tput sgr 0)
  echo $(tput setaf 2)aguu$(tput sgr 0) = $(tput setaf 3)"sudo apt update && sudo apt upgrade"$(tput sgr 0)
  echo $(tput setaf 2)agar$(tput sgr 0) = $(tput setaf 3)"sudo apt autoremove"$(tput sgr 0)
}
