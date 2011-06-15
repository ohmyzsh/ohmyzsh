#getting submodules
git submodule init
git submodule update
sudo brew install autojump
sudo brew install source-highlight
f=$(pwd)
ln -Fs $f"/zshrc" ~/.zshrc
