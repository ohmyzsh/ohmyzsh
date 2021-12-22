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
		cat $path_installscript | \
		sed 's/exec zsh -l//' |
	        sed 's/read -r opt/opt=y; echo "\n--- This time I am answering \\"yes\\" for you, but you will still have to type in the password of that user ---"/' \
		> $temp_installscript
		chown ${@[$#]} $temp_installscript && chmod +x $temp_installscript

		#try installing with sudo or su when not available
		if [[ -x $(which sudo) ]] ; then
			sudo -u ${@[$#]} $temp_installscript
			returncode=$?
		else
			if [[ -x $(which su) ]] ; then
				su -l ${@[$#]} -c $temp_installscript
				returncode=$?
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
