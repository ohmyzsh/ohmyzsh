# Copyright (c) 2021 Nikolas Garofil

adduser() {
	local returncode
	local result_string="Installation of 'Oh My Zsh' "
	local temp_installscript
	local path_installscript="$ZSH/tools/install.sh"


	#Create user, errors will be reported by the 'real' adduser
	#Use which/tail combination to call the binary instead of this function
	command adduser $@ || return 1


	echo "\nUser '${@[$#]}' has been created. I will now try to install 'Oh My Zsh'"
	if [[ -f $path_installscript ]] ; then

		#copy install.sh to a new file in temp that we can give the right owner to execute
		#and also make sure that after the install script we are no longer the new user
		temp_installscript=$(mktemp)
		cp $path_installscript $temp_installscript
		chown ${@[$#]} $temp_installscript && chmod +x $temp_installscript

		#try installing with sudo or su when not available
		if [[ -x "$commands[sudo]" ]] ; then
			sudo -u ${@[$#]} sh -c "$temp_installscript --unattended"
			returncode=$?
			if [[ -x "$commands[chsh]" ]] ; then
				sudo chsh -s $commands[zsh] ${@[$#]}
			else
				echo "'chsh' is not available, change the shell manually." > /dev/stderr
			fi
			returncode=$?
		else
			if [[ -x "$commands[su]" ]] ; then
				su -l ${@[$#]} -c "$temp_installscript --unattended"
				returncode=$?
				if [[ -x "$commands[chsh]" ]] ; then
					su -c "chsh -s $commands[zsh] ${@[$#]}"
				else
					echo "'chsh' is not available, change the shell manually." > /dev/stderr
				fi
			else
				echo "You can't become ${@[$#]} (no 'sudo' or 'su' available)" > /dev/stderr;
				returncode=1
			fi
		fi
		#cleanup
		rm $temp_installscript
	else
		echo "Installationscript '$path_installscript' not available" > /dev/stderr;
		returncode=1
	fi

	#mention the result
	if [[ $returncode -eq 0 ]]; then
		echo "$result_string succeeded."
	else
		echo "$result_string failed." > /dev/stderr
	fi

	return $returncode
}
