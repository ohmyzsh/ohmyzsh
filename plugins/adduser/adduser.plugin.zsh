# Copyright (c) 2021 Nikolas Garofil

_adduser_result() {
	local result_string="Installation of 'Oh My Zsh' for '$new_user'"

	#Erase the temporary copy of the installscript when necessary
	if [[ ! -z $temp_installscript  ]] ; then
		rm $temp_installscript
	fi

	#mention the result
	if [[ $1 -eq 0 ]]; then
		echo "$result_string succeeded."
	else
		echo "$result_string failed." > /dev/stderr
	fi

}

adduser() {
	local path_installscript="$ZSH/tools/install.sh"
	local unattended_options=" --unattended"

	local new_user=${@[$#]}
	local temp_installscript; local unattended_installer; local install_as_user; local change_shell;

	#Create user, errors will be reported by the 'real' adduser
	#Don't use $new_user so that we have all args
	command adduser $@ || return 1

	echo "\nUser '$new_user' has been created. I will now try to install 'Oh My Zsh'"

	if [[ ! -f $path_installscript ]] ; then
		echo "Installationscript '$path_installscript' not available" > /dev/stderr;
		_adduser_result 1
		return 1;
	fi

	#copy install.sh to a new file in temp that we can give the right owner to execute
	#and also make sure that after the install script we are no longer the new user
	temp_installscript=$(mktemp)
	cp $path_installscript $temp_installscript
	chown $new_user $temp_installscript && chmod +x $temp_installscript
	unattended_installer="$temp_installscript $unattended_options"

	if [[ ( ! -x "$commands[sudo]" ) && ( ! -x "$commands[su]" )  ]] ; then
		echo "You can't become $new_user (no 'sudo' or 'su' available)" > /dev/stderr;
		_adduser_result 1
		return 1;
	fi
	if [[ -x "$commands[sudo]" ]] ; then
		install_as_user="sudo -u $new_user sh -c '$unattended_installer'"
		change_shell="sudo chsh -s $commands[zsh] $new_user"
	else
		install_as_user="su -l $new_user -c '$unattended_installer'"
		change_shell="su -c 'chsh -s $commands[zsh] $new_user'"
	fi

	eval ${install_as_user}
	#mention the result before changing the shell (even with a bad result it's still installed)
	if [ ! $? -eq 0 ] ; then
		_adduser_result 1
		return 1
	fi

	if [[ ! -x "$commands[chsh]" ]] ; then
		echo "'chsh' is not available, change the shell manually." > /dev/stderr
	fi
	eval ${change_shell}
}
