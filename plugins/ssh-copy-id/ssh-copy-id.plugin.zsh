# There's probably a better way to define this if 
ssh-upload-id () {
	RSAKEY="${HOME}/.ssh/id_rsa.pub"
	DSAKEY="${HOME}/.ssh/id_dsa.pub"

	if [ $# -eq 2 ]; then
		KEY=$1
		if [ ! -r $KEY ]
		then
			echo "'$KEY' does not exist or is not readable"
			return 1
		fi
		SERVER=$2
	else
		if [ -r ${RSAKEY} ]; then
			KEY=$RSAKEY
		elif [ -r ${DSAKEY} ]; then
			KEY=$RSAKEY
		else
			echo "No RSA or DSA key found"
			return 1
		fi
		SERVER=$1
	fi

	if [ $# -lt 1 -o "$1" = "-h" ]; then
		echo "Usage: $0 [publickey_file] [user@]machine"
		return 1
	fi

	# testing above

	echo "Copying $KEY to $SERVER"

	cat $KEY | \
		ssh $SERVER 'mkdir -p -m 0700 ${HOME}/.ssh && \
		cat >> $HOME/.ssh/authorized_keys && \
		chmod 0600 $HOME/.ssh/authorized_keys'

	if [ $? -eq 0 ]; then
	    echo "Public key installed on $SERVER"
	    return 0
	else
	    echo "Sorry, an error occurred!"
	    return 1
	fi
}

# alias it to ssh-copy-id if it doesn't exist, like on OS X
EXISTING_CHECK=`which ssh-copy-id`
if [ $? -ne 0 ]; then
	alias ssh-copy-id=ssh-upload-id
fi
