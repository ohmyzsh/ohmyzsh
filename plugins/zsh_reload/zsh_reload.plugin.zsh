zsh_cache=$HOME/.zsh_cache
mkdir -p $zsh_cache

# reload zshrc
function src()
{
  autoload -U compinit zrecompile
  compinit -d $zsh_cache/zcomp-$HOST
  for f in $HOME/.zshrc $zsh_cache/zcomp-$HOST; do
    zrecompile -p $f && rm -f $f.zwc.old
  done
  source ~/.zshrc
}