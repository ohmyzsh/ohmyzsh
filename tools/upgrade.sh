current_path=`pwd`
echo "Upgrading Oh My Zsh"
( cd $ZSH && git pull origin master )
echo "Done."
cd $current_path