if [ ! -f $ZSH/plugins/chucknorris/fortunes/chucknorris.dat ]; then
    strfile $ZSH/plugins/chucknorris/fortunes/chucknorris $ZSH/plugins/chucknorris/fortunes/chucknorris.dat
fi

alias chuck="fortune -a $ZSH/plugins/chucknorris/fortunes"
alias chuck_cow="chuck | cowthink"
