if ! (( $+commands[curl] )); then
    echo "rand-quote plugin needs curl to work" >&2
    return
fi

function quote {
    emulate -L zsh
    Q=$(curl -s --connect-timeout 2 "http://www.quotationspage.com/random.php" | iconv -c -f ISO-8859-1 -t UTF-8 | grep -m 1 "dt ")

    TXT=$(echo "$Q" | sed -e 's/<\/dt>.*//g' -e 's/.*html//g' -e 's/^[^a-zA-Z]*//' -e 's/<\/a..*$//g')
    WHO=$(echo "$Q" | sed -e 's/.*\/quotes\///g' -e 's/<.*//g' -e 's/.*">//g')

    [[ -n "$WHO" && -n "$TXT" ]] && print -P "%F{3}${WHO}%f: “%F{5}${TXT}%f”"
}
