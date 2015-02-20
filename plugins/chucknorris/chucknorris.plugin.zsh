() {
  # Automatically generate or update Chuck's compiled fortune data file
  local fdir=$ZSH/plugins/chucknorris/fortunes
  if [[ ! -f $fdir/chucknorris.dat ]] || [[ $fdir/chucknorris.dat -ot $fdir/chucknorris ]]; then
    strfile $fdir/chucknorris $fdir/chucknorris.dat
  fi

  # Aliases
  alias chuck="fortune -a $fdir"
  alias chuck_cow="chuck | cowthink"
}

