# Aliases
alias a='sudo apt-get'
alias achk='sudo apt-get check'			# check dependencies
alias ai='sudo apt-get install'			# install deb
alias ar='sudo apt-get remove'			# remove deb
alias arp='sudo apt-get remove --purge'		# remove deb and purge config
alias aarp='sudo apt-get autoremove --purge'	# autoremove and purge config
alias aud='sudo apt-get update'			# update apt cache
#alias aug='sudo apt-get upgrade'		# upgrade debs
alias aug='sudo apt-get dselect-upgrade'	# upgrade debs with dselect
alias ac='sudo apt-get clean'			# clean deb files from cache
alias as='apt-cache search'			# serch for deb in apt cache
alias asi='dpkg -l | grep'			# serch for installed deb
alias aed='sudo $EDITOR /etc/apt/sources.list'	# edit repositories list
