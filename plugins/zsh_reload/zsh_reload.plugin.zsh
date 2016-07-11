# reload zshrc
function src()
{
  local cache=$ZSH_CACHE_DIR
  autoload -U compinit zrecompile
  compinit -d "$cache/zcomp-$HOST"

  for f in ~/.zshrc "$cache/zcomp-$HOST"; do
    zrecompile -p $f && command rm -f $f.zwc.old
  done

  source ~/.zshrc
}
