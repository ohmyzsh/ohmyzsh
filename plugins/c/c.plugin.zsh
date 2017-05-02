# add function that cds to ~/code, with tab-completion
function c() {
  cd ~/code/$1;
}

fpath=($ZSH/plugins/c $fpath)
autoload -U compinit
compinit -i
