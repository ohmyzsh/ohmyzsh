
source ./common

if [ ! -d ~/.oh-my-zsh ]; then
  warn 'Cannot find ~/.oh-my-zsh'
  exit 1
fi
proclaim 'Upgrading Oh My Zsh'

# I think pushd/popd might be cleaner,
# but more of a risk if they are over-ridden?
current_path=`pwd`

# Is there a better way to ensure $ZSH is passed?
cd "${ZSH:-$HOME/.oh-my-zsh}" \
 && git pull origin master \
 || ( warn 'Cannot upgrade Zsh!'; cd "$current_path"; exit 1 )

proclaim '         __                                     __   '
proclaim '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
proclaim ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
proclaim '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
proclaim '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
proclaim '                        /____/                       '
proclaim 'Hooray! Oh My Zsh has been updated and/or is at the current version.'
proclaim 'To keep up on the latest, be sure to follow Oh My Zsh on twitter:'
proclaim "${COLOR_WHITE}http://twitter.com/ohmyzsh"

cd "$current_path"

