current_path=`pwd`
echo "Upgrading Oh My Zsh"
( cd $ZSH && git pull origin master )
echo "Hooray! Oh My Zsh has been updated and/or is at the current version. \nAny new updates will be reflected when you start your next terminal session."
cd $current_path