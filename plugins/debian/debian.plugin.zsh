# https://github.com/dbb/
#
# Debian-related zsh aliases and functions for zsh


# Aliases ###################################################################

# Some self-explanatory aliases
alias acs="apt-cache search"
alias afs='apt-file search --regexp'
alias aps='aptitude search'
alias as="aptitude -F \"* %p -> %d \n(%v/%V)\" \
		--no-gui --disable-columns search"	# search package
alias apsrc='apt-get source'
alias apv='apt-cache policy'

# aliases that use su -c ##############
alias apdg='su -c "aptitude update && aptitude safe-upgrade"'
alias apud='su -c "aptitude update"'
alias apug='su -c "aptitude safe-upgrade"'
# end aliases that use su -c ##########

# aliases that use sudo ###############
alias ad="sudo apt-get update"				# update packages lists
alias au="sudo apt-get update && \
		sudo apt-get dselect-upgrade"		# upgrade packages
alias ai="sudo apt-get install"				# install package
alias ar="sudo apt-get remove --purge && \
		sudo apt-get autoremove --purge"	# remove package
alias ac="sudo apt-get clean && sudo apt-get autoclean" # clean apt cache
# end aliases that use sudo ###########

# print all installed packages
alias allpkgs='aptitude search -F "%p" --disable-columns ~i'

# Install all .deb files in the current directory.
# Warning: you will need to put the glob in single quotes if you use:
# glob_subst
alias di='su -c "dpkg -i ./*.deb"'

# Create a basic .deb package
alias mydeb='time dpkg-buildpackage -rfakeroot -us -uc'

# Remove ALL kernel images and headers EXCEPT the one in use
alias kclean='su -c '\''aptitude remove -P ?and(~i~nlinux-(ima|hea) ?not(~n`uname -r`))'\'' root'



# Functions #################################################################

# install packages without sudo
apin() {
    cmd="su -lc 'aptitude -P install $@' root"
    print "$cmd"
    eval "$cmd"
}

# create a simple script that can be used to 'duplicate' a system
apt-copy() {
	print '#!/bin/sh'"\n" > apt-copy.sh

	list=$(perl -m'AptPkg::Cache' -e '$c=AptPkg::Cache->new; for (keys %$c){ push @a, $_ if $c->{$_}->{'CurrentState'} eq 'Installed';} print "$_ " for sort @a;')

	print 'aptitude install '"$list\n" >> apt-copy.sh

	chmod +x apt-copy.sh
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


