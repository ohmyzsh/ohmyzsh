p="$ZSH/plugins/hirakata/"
f=$(cat $p"files/hk_symbols.txt")

function hirakata() {
    random_symbol=$(echo "$f" | shuf -n1)

    symbol=$(echo $random_symbol | cut -d ' ' -f1)
    sound=$(echo $random_symbol | cut -d ' ' -f2)

    ( mpg321 $p'sounds/'$sound & ) > /dev/null 2>&1
    echo $symbol
}