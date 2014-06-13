p="$ZSH/plugins/hirakata/"
fh=$(cat $p"files/hira.txt")
fk=$(cat $p"files/kata.txt")

function hirakata() {
    random_symbol=$(echo "$fh\n$fk" | shuf -n1)
    romaji=0
    mute=0

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
            "mute")
                mute=1
                ;;
        esac
    done

    symbol=$(echo $random_symbol | cut -d ' ' -f1)
    sound=$(echo $random_symbol | cut -d ' ' -f2)

    echo -n $symbol

    if [ $romaji -eq 1 ]; then
        romaji=$(echo $sound | cut -d '.' -f1)
        echo -n " ($romaji)"
    fi

    if [ $mute -eq 0 ]; then
        (mpg321 -q $p/sounds/$sound & ) > /dev/null 2>&1
    fi
}
