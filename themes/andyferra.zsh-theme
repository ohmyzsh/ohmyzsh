function git_branch() {
	branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

	if [ "$branch" != "" ]; then
		if [ "$branch" = "master" ]; then
			echo "\e[0;32m[$branch]\e[0;37m"
		else
			echo "\e[0;31m[$branch]\e[0;37m"
		fi
	else
		echo ""
	fi
}

PROMPT='
%c $(git_branch)
$ '
