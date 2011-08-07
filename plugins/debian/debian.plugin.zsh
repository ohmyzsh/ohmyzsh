# Authors:
# https://github.com/AlexBio
# https://github.com/dbb
#
# Debian-related zsh aliases and functions for zsh

# Set to 'apt-get' or 'aptitude'
apt_pref='aptitude'

# Use sudo by default if it's installed
if [[ -e $( which sudo ) ]]; then
    use_sudo=1
fi

# Aliases ###################################################################

# Some self-explanatory aliases
alias acs="apt-cache search"
alias aps='aptitude search'
alias as="aptitude -F \"* %p -> %d \n(%v/%V)\" \
		--no-gui --disable-columns search"	# search package

# apt-file
alias afs='apt-file search --regexp'


# These are apt-get only
alias asrc='apt-get source'
alias ap='apt-cache policy'

# superuser operations ################
if [[ $use_sudo -eq 1 ]]; then
    alias ai="sudo $apt_pref install"
    alias ad="sudo $apt_pref update"
    alias afu='sudo apt-file update'
    alias ag="sudo $apt_pref upgrade"
    alias adg="sudo $apt_pref update && sudo $apt_pref upgrade"
    alias ap="sudo $apt_pref purge"
    alias ar="sudo $apt_pref remove"

    if [[ $apt_pref -eq 'apt-get' ]]; then
        alias ads="sudo $apt_pref dselect-upgrade"
    fi
    
    # Install all .deb files in the current directory.
    # Warning: you will need to put the glob in single quotes if you use:
    # glob_subst
    alias di='sudo dpkg -i ./*.deb'

    # Remove ALL kernel images and headers EXCEPT the one in use
    alias kclean='sudo aptitude remove -P ?and(~i~nlinux-(ima|hea) ?not(~n`uname -r`))'
else
    alias ai='apin' 
    alias ad='su -lc "'"$apt_pref"' update" root'
    alias afu='su -lc "apt-file update"'
    alias ag='su -lc "'"$apt_pref"' safe-upgrade" root'
    alias adg='su -lc "'"$apt_pref"' update && aptitude safe-upgrade" root'
    alias di='su -lc "dpkg -i ./*.deb" root'
    # Remove ALL kernel images and headers EXCEPT the one in use
    alias kclean='su -lc '\''aptitude remove -P ?and(~i~nlinux-(ima|hea) ?not(~n`uname -r`))'\'' root'
fi
# end superuser operations ##########


# print all installed packages
alias allpkgs='aptitude search -F "%p" --disable-columns ~i'



# Create a basic .deb package
alias mydeb='time dpkg-buildpackage -rfakeroot -us -uc'





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

