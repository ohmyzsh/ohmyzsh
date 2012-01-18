# Restart a rack app running under pow
# http://pow.cx/
#
# Adds a kapow command that will restart an app
#
#   $ kapow myapp
#   $ kapow # defaults to current directory
#
# Supports command completion.
#
# If you are not already using completion you might need to enable it with
# 
#    autoload -U compinit compinit
#
# Thanks also to Christopher Sexton
# https://gist.github.com/965032
#
function kapow {
	FOLDERNAME=$1
	if [ -z "$FOLDERNAME" ]; then; FOLDERNAME=${PWD##*/}; fi
	touch ~/.pow/$FOLDERNAME/tmp/restart.txt;
	if [ $? -eq 0 ]; then; echo "pow: restarting $FOLDERNAME" ; fi
}

compctl -W ~/.pow -/ kapow
