# Automatically generate or update Chuck's compiled fortune data file
DIR=${0:h}/fortunes
if [[ ! -f $DIR/chucknorris.dat ]] || [[ $DIR/chucknorris.dat -ot $DIR/chucknorris ]]; then
  strfile $DIR/chucknorris $DIR/chucknorris.dat
fi

# Aliases
alias chuck="fortune -a $DIR"
alias chuck_cow="chuck | cowthink"

unset DIR