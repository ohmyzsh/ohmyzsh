current_path=`pwd`
echo "Upgrading Oh My Zsh"
( cd $ZSH && git pull origin master )
echo '         __                                     __  '
echo '  ____  / /_     ____ ___  __  __   ____  _____/ /_ '
echo ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
echo '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
echo '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
echo '                        /____/'
echo "Hooray! Oh My Zsh has been updated and/or is at the current version. \nAny new updates will be reflected when you start your next terminal session."
echo "To keep up on the latest, be sure to follow Oh My Zsh on twitter: http://twitter.com/ohmyzsh"
cd $current_path