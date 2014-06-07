p="$ZSH_CUSTOM/plugins/hirakata/"
f=$(cat $p"files/hk_symbols.txt")

function hirakata() {
    random_symbol=$(echo "$fh\n$fk" | shuf -n1)
    romaji=0

    for arg in "$@"
    do
        case "$arg" in
            "romaji")
                romaji=1
                ;;
            "hiragana")
                random_symbol=$(echo "$fh" | shuf -n1)
                ;;
            "katakana")
                random_symbol=$(echo "$fk" | shuf -n1)
                ;;
        esac
    done

    symbol=$(echo $random_symbol | cut -d ' ' -f1)
    sound=$(echo $random_symbol | cut -d ' ' -f2)
    (mpg321 -q $HK/sounds/$sound & ) > /dev/null 2>&1
    echo -n $symbol

    if [ $romaji -eq 1 ]; then
        romaji=$(echo $sound | cut -d '.' -f1)
        echo -n " ($romaji)"
    fi
}
