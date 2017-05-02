
# Nano
# Sudo nano if files are not writeable for current user

alias nano='nano'

function nano () {
  if [[ (-G $1) || (-O $1) ]]
	then
		nano $1
	else
		sudo nano $1
	fi
}