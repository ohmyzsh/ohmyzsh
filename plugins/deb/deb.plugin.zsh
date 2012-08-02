# Aliases
alias as="aptitude -F \"* %p -> %d \n(%v/%V)\" \
		--no-gui --disable-columns search"	# search package
alias ad="sudo apt-get update"				# update packages lists
alias au="sudo apt-get update && \
		sudo apt-get dselect-upgrade"		# upgrade packages
alias ai="sudo apt-get install"				# install package
alias ar="sudo apt-get remove --purge && \
		sudo apt-get autoremove --purge"	# remove package
alias ap="apt-cache policy"				# apt policy
alias av="apt-cache show"				# show package info
alias acs="apt-cache search"                            # search package
alias ac="sudo apt-get clean && sudo apt-get autoclean" # clean apt cache
