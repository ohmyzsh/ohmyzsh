current_path=`pwd`
echo "Upgrading Oh My Zsh"

git_branches=`git remote -v`
default_origin=`echo $git_branches | egrep 'origin\s+https://github.com/robbyrussell/oh-my-zsh\.git'`
upgrade_cmd="git pull origin master"
if [ "N$default_origin" = "N" ]; then
	upstream_branch=`echo $git_branches | egrep 'upstream\s+https://github.com/robbyrussell/oh-my-zsh\.git'`
	if [ "N$upstream_branch" = "N" ]; then
		upgrade_cmd="git remote add upstream https://github.com/robbyrussell/oh-my-zsh/; git fetch upstream; git merge upstream/master"
	else
		upgrade_cmd="git fetch upstream; git merge upstream/master"
	fi
fi

( cd $ZSH && eval "$upgrade_cmd" )
echo '         __                                     __  '
echo '  ____  / /_     ____ ___  __  __   ____  _____/ /_ '
echo ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
echo '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
echo '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
echo '                        /____/'
echo "Hooray! Oh My Zsh has been updated and/or is at the current version. \nAny new updates will be reflected when you start your next terminal session."
echo "To keep up on the latest, be sure to follow Oh My Zsh on twitter: http://twitter.com/ohmyzsh"
cd $current_path
