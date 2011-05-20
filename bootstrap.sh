#getting submodules
git submodule init
git submodule update
sudo brew install autojump
f=$(pwd)
ln -Fs $f"/zshrc" ~/.zshrc
