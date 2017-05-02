# Plugin to make life of system administrators easier
# Author: Nilesh (http://nileshgr.com)
#
# How to use this plugin
#
# plugins=(... ssh ...)
# 
################# Plugin configuration #################
#
# Add in your zshrc before sourcing oh-my-zsh.zsh --
#
# typeset -A ssh_hosts
# ssh_hosts=('nickname' 'user@host1' \
#            'nickname1' 'host2' \
#            'nickname3' 'user2@host1' \
#           )
#
################## End configuration ###################
#
# Once you've done that, reload your zshrc and try
# ssh <TAB>
# It should give you the list of nicknames you specified (which can be selected by tabs)
#
# If you want to pass custom options to the ssh command, you can either
# add them in the map as '-v user@host1'
# or call the function as
# ssh nickname <option>

if [ -z "$ssh_hosts" ]; then
	echo "ssh_hosts map not set"
	return
fi

local actual_ssh=$(whence -p ssh)

function ssh() {
	if [ $# -lt 1 ]; then
		echo NO HOST
		return 1
	fi
	
	local param=$1
	local host=$ssh_hosts[$param]

	if [ -z "$host" ]; then
		$actual_ssh $*
		return
	fi
	
	shift

	$actual_ssh $(echo $ssh_hosts[$param]) $* # $() to circumvent ssh from b0rking if options are present in map
}

function _ssh() {
	for comp in ${(k)ssh_hosts}; do
		compadd $comp
	done
}

compdef _ssh ssh
