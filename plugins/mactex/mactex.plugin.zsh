LATEX=`which latex`
if [[ $LATEX == 'latex not found' ]] ; then
	if [ -d /usr/texbin ] ; then
		export PATH=/usr/texbin:${PATH}
	fi
	if [ -d ~/texbin ] ; then
		export PATH=~/texbin;${PATH}
	fi
fi