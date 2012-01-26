function load_omzs_on_login {
	profile_file="$HOME/.zshrc"
	if [[ -f "${profile_file}" ]] &&
	  ! grep '$ZSH/oh-my-zsh.sh' "$profile_file" >/dev/null 2>&1
	then
	  echo '[[ -r $ZSH/oh-my-zsh.sh ]] && . $ZSH/oh-my-zsh.sh' >> "$profile_file"
		echo "- oh-my-zsh will now load on login."
	else
		echo "- oh-my-zsh is already setup to load on login."
	fi
  return 0
}

function load_omzs_on_alias {
	profile_file="$HOME/.zshrc"
	if [[ -f "${profile_file}" ]] &&
	  ! grep 'alias omzs=". $ZSH/oh-my-zsh.sh"' "$profile_file" >/dev/null 2>&1
	then
	  echo 'alias omzs=". $ZSH/oh-my-zsh.sh"' >> "$profile_file"
		echo "- oh-my-zsh will now load when you execute 'omzs'."
	else
		echo "- oh-my-zsh is already setup to load using the 'omzs' alias."
	fi
  return 0
}


# Propagate your environment system to a remote host
function propagate_omzs_to_host {
	if [[ $# -lt 1 ]]; then
		echo "Usage: propagate_omzs_to_host [user@]HOSTNAME"
		return
	fi

	host=$1
	OH_MY_ZSH=$HOME/env.tar.gz
	PWD=`pwd`
	cd $HOME
	echo "- compressing local environment..."
	tar cfvz $OH_MY_ZSH .oh-my-zsh/ &> /dev/null
	echo "- copying environment to $host..."
	scp $OH_MY_ZSH $host:
	if [[ $? != 0 ]]; then echo "> remote copy failed [scp $OH_MY_ZSH $host]!"; return; fi
	echo "- installing environment on $host..."
	ssh $host "rm -rf ~/.oh-my-zsh/ && gunzip < env.tar.gz |tar xfv -" &> /dev/null
	echo "- done.  don't forget to run 'load_omzs_on_login' or 'load_omzs_on_alias'"
	cd $PWD
}

function _stub_new_host_environment {
	mkdir -p $1
	touch "$1/env.sh"
	touch "$1/functions.sh"
	if [[ ! -f "$1/alias.sh" ]]; then
		echo "# Add your host specific aliases here:\n# Example: alias home='cd \$HOME' " >> "$1/alias.sh"
	fi
	if [[ ! -f "$1/path.sh" ]]; then
		echo "# Add paths like this:\n# pathmunge \"/Developer/usr/bin\"" >> "$1/path.sh"
	fi
}

# Configure environment settings for your local machine.
function config_omzs_for_this_host {
	DIR="$DOT_ENV_PATH/host/$HOSTNAME"
	_stub_new_host_environment $DIR
	cd "$DIR"
	echo "- edit these files to customize your local environment."
	ls -1AtF
}

# Configure environment settings for a specified HOSTNAME
function config_omzs_for_host {
	if [[ $# -lt 1 ]]; then
		echo_warn "Usage: config_omzs_for_host HOSTNAME"
		return
	fi
	host=$1
	DIR="$DOT_ENV_PATH/host/$host"
	_stub_new_host_environment $DIR
	cd "$DIR"
	echo "- edit these files to customize your [$host] environment."
	echo "- when you are finished run 'propagate_omzs_to_host $host'."
	ls -1AtF
}

