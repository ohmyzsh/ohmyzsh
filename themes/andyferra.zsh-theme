function git_branch() {
	branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

	if [ "$branch" != "" ]; then
		if [ "$branch" = "master" ]; then
			echo "%{${FG[154]}%}($branch)%{${reset_color}%}"
		else
			echo "%{${FG[161]}%}($branch)%{${reset_color}%}"
		fi
	else
		echo ""
	fi
}

PROMPT='
%c $(git_branch)
%{${FG[237]}%}↪%{${reset_color}%}  '
