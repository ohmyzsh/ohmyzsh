#getting submodules
git submodule init
git submodule update
f=$(pwd)
ln -Fs $f"/zshrc" ~/.zshrc
